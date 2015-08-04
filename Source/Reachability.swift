//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import SystemConfiguration

public enum ReachabilityStatus {
	/**
		:name:	NotRechable
		:description:	Network is not reachable.
	*/
	case NotReachable
	
	/**
		:name:	ReachableViaWiFi
		:description:	Network is reachable via Wifi.
	*/
	case ReachableViaWiFi
	
	/**
		:name:	ReachableViaWWAN
		:description:	Network is reachable via WWAN.
	*/
	case ReachableViaWWAN
}

@objc(ReachabilityDelegate)
public protocol ReachabilityDelegate {
	/**
		:name:	reachabilityDidChangeStatus
		:description:	An optional Delegate that is called when the Network
		ReachabilityStatus changes.
		:param:	reachability	Reachability	The calling Reachability instance.
	*/
	optional func reachabilityDidChangeStatus(reachability: Reachability)
	
	/**
		:name:	reachabilityDidBecomeReachable
		:description:	An optional Delegate that is called when the Network
		ReachabilityStatus is available.
		:param:	reachability	Reachability	The calling Reachability instance.
	*/
	optional func reachabilityDidBecomeReachable(reachability: Reachability)
	
	/**
		:name:	reachabilityDidBecomeUnreachable
		:description:	An optional Delegate that is called when the Network
		ReachabilityStatus is no longer available.
		:param:	reachability	Reachability	The calling Reachability instance.
	*/
	optional func reachabilityDidBecomeUnreachable(reachability: Reachability)
}

@objc(Reachability)
public class Reachability {
	/**
		:name: reachability
		:description:	Internal SCNetworkReachability value.
		:returns:	SCNetworkReachability?
	*/
	private var reachability: SCNetworkReachability?
	
	/**
		:name:	previousFlags
		:description:	Holds the previous SCNetworkReachabilityFlags value
		when the network connectivity changes.
		:returns:	SCNetworkReachabilityFlags?
	*/
	private var previousFlags: SCNetworkReachabilityFlags?
	
	/**
		:name:	currentFlags
		:description:	Holds the current SCNetworkReachabilityFlags value
		when the network connectivity changes.
		:returns:	SCNetworkReachabilityFlags?
	*/
	private var currentFlags: SCNetworkReachabilityFlags {
		var flags: SCNetworkReachabilityFlags = 0
		return 0 == SCNetworkReachabilityGetFlags(reachability, &flags) ? 0 : flags
	}
	
	/**
		:name:	timer
		:description:	Internal dispatch timer for connectivity watching.
		:returns:	dispatch_source_t?
	*/
	private var timer: dispatch_source_t?
	
	/**
		:name:	queue
		:description:	Internal dispatch queue for connectivity watching.
		:returns:	dispatch_queue_t?
	*/
	private lazy var queue: dispatch_queue_t = {
		return dispatch_queue_create("io.graphkit.Reachability", nil)
	}()
	
	/**
		:name:	status
		:description:	Current ReachabilityStatus value.
		:returns:	ReachabilityStatus
	*/
	public private(set) var status: ReachabilityStatus
	
	/**
		:name:	onStatusChange
		:description:	An Optional callback to set when network
		availability changes.
		:returns:	((reachability: Reachability) -> ())?
	*/
	public var onStatusChange: ((reachability: Reachability) -> ())?
	
	/**
		:name:	isReachableOnWWAN
		:description:	A boolean flag that allows Reachability to 
		be detected when on WWAN.
		:returns:	Bool
	*/
	public var isReachableOnWWAN: Bool
	
	/**
		:name:	isRunningOnDevice
		:description:	A boolean flag that indicates the user
		is using a mobile device or not.
		:returns:	Bool
	*/
	public var isRunningOnDevice: Bool = {
		#if os(iOS) && (arch(i386) || arch(x86_64))
			return false
		#else
			return true
		#endif
	}()
	
	/**
		:name:	delegate
		:description:	An optional Delegate to set that is called
		when Reachability settings change.
		:returns:	ReachabilityDelegate?
	*/
	public weak var delegate: ReachabilityDelegate?
	
	/**
		:name: reachabilityForInternetConnection
		:description:	A Class level method that returns a Reachability
		instance that detects network connectivity changes.
		:returns:	Reachability
	*/
	public class func reachabilityForInternetConnection() -> Reachability {
		var addr: sockaddr_in = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		addr.sin_len = UInt8(sizeofValue(addr))
		addr.sin_family = sa_family_t(AF_INET)
		return Reachability(reachability: withUnsafePointer(&addr) {
			SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0)).takeRetainedValue()
		})
	}
	
	private init() {
		status = .NotReachable
		isReachableOnWWAN = true
	}
	
	/**
		:name:	init
		:description:	A Constructor that allows for the SCNetworkReachability
		reference to be set externally.
		:param:	reachability	SCNetworkReachability	An external SCNetworkReachability
		reference.
	*/
	public convenience init(reachability: SCNetworkReachability) {
		self.init()
		self.reachability = reachability
	}
	
	deinit {
		stopWatcher()
		reachability = nil
	}
	
	/**
		:name:	startWatcher
		:description:	Start watching for network changes.
	*/
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
	
	/**
		:name:	stopWatcher
		:description:	Stop watching for network changes.
	*/
	public func stopWatcher() {
		if nil != timer {
			dispatch_source_cancel(timer!)
			timer = nil
		}
	}
	
	/**
		:name:	watcherUpdate
		:description:	Called when the Reachability changes.
	*/
	private func watcherUpdate() {
		let flags: SCNetworkReachabilityFlags = currentFlags
		if flags != previousFlags {
			dispatch_async(dispatch_get_main_queue(), { _ in
				let s: ReachabilityStatus = self.status
				self.statusDidChange(flags)
				self.previousFlags = flags
			})
		}
	}
	
	/**
		:name:	statusDidChange
		:description:	When the status changes, this method calls the
		Delegate handles.
		:param:	flags	SCNetworkReachabilityFlags Flags that determine
		the changed state.
	*/
	private func statusDidChange(flags: SCNetworkReachabilityFlags) {
		onStatusChange?(reachability: self)
		delegate?.reachabilityDidChangeStatus?(self)
		
		if isReachable(flags) {
			status = isWWAN(flags) ? .ReachableViaWWAN : .ReachableViaWiFi
			delegate?.reachabilityDidBecomeReachable?(self)
		} else {
			status = .NotReachable
			delegate?.reachabilityDidBecomeUnreachable?(self)
		}
	}
	
	/**
		:name:	isRaachable
		:description:	Determines whether the network is reachable or not.
		:returns:	Bool
	*/
	private func isReachable(flags: SCNetworkReachabilityFlags) -> Bool {
		return	!(!(0 != flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsReachable)) ||
			(0 != flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsTransientConnection | kSCNetworkReachabilityFlagsConnectionRequired)) ||
			(isRunningOnDevice && isWWAN(flags) && !isReachableOnWWAN))
	}
	
	/**
		:name:	isWWAN
		:description:	Determines whether the network is WWAN.
		:returns:	Bool
	*/
	private func isWWAN(flags: SCNetworkReachabilityFlags) -> Bool {
		#if os(iOS)
			return 0 != flags & SCNetworkReachabilityFlags(kSCNetworkReachabilityFlagsIsWWAN)
		#else
			return false
		#endif
	}
}
