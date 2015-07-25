/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

import SystemConfiguration

public enum ReachabilityStatus {
	case NotReachable
	case ReachableViaWiFi
	case ReachableViaWWAN
}

@objc(ReachabilityDelegate)
public protocol ReachabilityDelegate {
	optional func reachabilityDidChangeStatus(reachability: Reachability)
	optional func reachabilityDidBecomeReachable(reachability: Reachability)
	optional func reachabilityDidBecomeUnreachable(reachability: Reachability)
}

@objc(Reachability)
public class Reachability {
	private var reachabilityRef: SCNetworkReachability?
	private var previousFlags: SCNetworkReachabilityFlags?
	private var currentFlags: SCNetworkReachabilityFlags {
		var flags: SCNetworkReachabilityFlags = 0
		return 0 == SCNetworkReachabilityGetFlags(reachabilityRef, &flags) ? 0 : flags
	}
	
	private var timer: dispatch_source_t?
	private lazy var queue: dispatch_queue_t = {
		return dispatch_queue_create("io.graphkit.reachability", nil)
	}()
	
	public private(set) var status: ReachabilityStatus
	public var onStatusChange: ((previous: ReachabilityStatus, current: ReachabilityStatus) -> ())?
	
	public var isReachableOnWWAN: Bool
	public var isRunningOnDevice: Bool = {
		#if os(iOS) && (arch(i386) || arch(x86_64))
			return false
		#else
			return true
		#endif
	}()
	
	public weak var delegate: ReachabilityDelegate?
	
	public class func reachabilityForInternetConnection() -> Reachability {
		var addr: sockaddr_in = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		addr.sin_len = UInt8(sizeofValue(addr))
		addr.sin_family = sa_family_t(AF_INET)
		return Reachability(reachabilityRef: withUnsafePointer(&addr) {
			SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0)).takeRetainedValue()
		})
	}
	
	public init() {
		status = .NotReachable
		isReachableOnWWAN = true
	}
	
	public convenience init(reachabilityRef: SCNetworkReachability) {
		self.init()
		self.reachabilityRef = reachabilityRef
	}
	
	deinit {
		stopWatcher()
		reachabilityRef = nil
	}
	
	public func startWatcher() -> Bool {
		timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
		
		if nil == timer  {
			return false
		}
		
		dispatch_source_set_timer(timer!, dispatch_walltime(nil, 0), 500 * NSEC_PER_MSEC, 100 * NSEC_PER_MSEC)
		dispatch_source_set_event_handler(timer!, { _ in
			self.watcherUpdate()
		})
		previousFlags = currentFlags
		dispatch_resume(timer!)
		return true
	}
	
	public func stopWatcher() {
		if nil != timer {
			dispatch_source_cancel(timer!)
			timer = nil
		}
	}
	
	private func watcherUpdate() {
		let flags: SCNetworkReachabilityFlags = currentFlags
		if flags != previousFlags {
			dispatch_async(dispatch_get_main_queue(), { _ in
				let s: ReachabilityStatus = self.status
				self.statusDidChange(flags)
				self.previousFlags = flags
				self.onStatusChange?(previous: s, current: self.status)
			})
		}
	}
	
	private func statusDidChange(flags: SCNetworkReachabilityFlags) {
		if isReachable(flags) {
			status = isWWAN(flags) ? .ReachableViaWWAN : .ReachableViaWiFi
			delegate?.reachabilityDidBecomeReachable?(self)
		} else {
			status = .NotReachable
			delegate?.reachabilityDidBecomeUnreachable?(self)
		}
		delegate?.reachabilityDidChangeStatus?(self)
	}
	
	private func isReachable(flags: SCNetworkReachabilityFlags) -> Bool {
		return	!(!(0 != flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsReachable)) ||
			(0 != flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsTransientConnection | kSCNetworkReachabilityFlagsConnectionRequired)) ||
			(isRunningOnDevice && isWWAN(flags) && !isReachableOnWWAN))
	}
	
	private func isWWAN(flags: SCNetworkReachabilityFlags) -> Bool {
		return 0 != flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsWWAN)
	}
}
