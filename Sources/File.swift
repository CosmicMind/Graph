/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Graph nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation

/**
:name: VideoExtension
*/
public enum VideoExtension {
	case MOV
	case M4V
	case MP4
}

/**
:name: VideoExtensionToString
*/
public func VideoExtensionToString(type: VideoExtension) -> String {
	switch type {
	case .MOV:
		return "mov"
	case .M4V:
		return "m4v"
	case .MP4:
		return "mp4"
	}
}

/**
:name: ImageExtensionToString
*/
public enum ImageExtension {
	case PNG
	case JPG
	case JPEG
	case TIFF
	case GIF
}

/**
:name: ImageExtensionToString
*/
public func ImageExtensionToString(type: ImageExtension) -> String {
	switch type {
	case .PNG:
		return "png"
	case .JPG:
		return "jpg"
	case .JPEG:
		return "jpeg"
	case .TIFF:
		return "tiff"
	case .GIF:
		return "gif"
	}
}

/**
:name: TextExtension
*/
public enum TextExtension {
	case TXT
	case RTF
	case HTML
}

/**
:name:	TextExtensionToString
*/
public func TextExtensionToString(type: TextExtension) -> String {
	switch type {
	case .TXT:
		return "txt"
	case .RTF:
		return "rtf"
	case .HTML:
		return "html"
	}
}

public enum SQLiteExtension {
	case SQLite
	case SQLiteSHM
}

/**
:name:	SQLiteExtensionToString
*/
public func SQLiteExtensionToString(type: SQLiteExtension) -> String {
	switch type {
	case .SQLite:
		return "sqlite"
	case .SQLiteSHM:
		return "sqlite-shm"
	}
}

/**
:name: Schemas used with Persistant Storage
*/
public struct Schema {
	public static let File: String = "File://"
}

/**
:name:	Result enum
*/
public enum Result {
	case Success
	case Failure(error: NSError)
}

/**
:name:	FileType enum
*/
public enum FileType {
	case Directory
	case Image
	case Video
	case Text
	case SQLite
	case Unknown
}

public struct File {
	/**
	:name:	documentDirectoryPath
	*/
	public static let documentDirectoryPath: NSURL? = File.pathForDirectory(.DocumentDirectory)
	
	/**
	:name:	libraryDirectoryPath
	*/
	public static let libraryDirectoryPath: NSURL? = File.pathForDirectory(.LibraryDirectory)
	
	/**
	:name:	applicationDirectoryPath
	*/
	public static let applicationSupportDirectoryPath: NSURL? = File.pathForDirectory(.ApplicationSupportDirectory)
	
	/**
	:name:	cachesDirectoryPath
	*/
	public static let cachesDirectoryPath: NSURL? = File.pathForDirectory(.CachesDirectory)
	
	/**
	:name:	rootPath
	*/
	public static var rootPath: NSURL? {
		let path: NSURL? = File.documentDirectoryPath
		var pathComponents = path?.pathComponents
		pathComponents?.removeLast()
		return NSURL(string: Schema.File.stringByAppendingString((pathComponents?.joinWithSeparator("/"))!))
	}
	
	/**
	:name:	fileExistsAtPath
	*/
	public static func fileExistsAtPath(URL: NSURL) -> Bool {
		return NSFileManager.defaultManager().fileExistsAtPath(URL.path!)
	}
	
	/**
	:name:	contentsEqualAtPath
	*/
	public static func contentsEqualAtPath(path: NSURL, andPath: NSURL) -> Bool {
		return NSFileManager.defaultManager().contentsEqualAtPath(path.path!, andPath: andPath.path!)
	}
	
	
	/**
	:name:  isWritableFileAtPath
	*/
	public static func isWritableFileAtPath(URL: NSURL) -> Bool {
		return NSFileManager.defaultManager().isWritableFileAtPath(URL.path!)
	}
	
	/**
	:name:  removeItemAtPath
	*/
	public static func removeItemAtPath(path: NSURL, completion: ((removed: Bool?, error: NSError?) -> Void)) {
		do {
			try NSFileManager.defaultManager().removeItemAtPath(path.path!)
			completion(removed: true, error: nil)
		} catch let error as NSError {
			completion(removed: nil, error: error)
		}
	}
	
	/**
	:name:	createDirectory
	*/
	public static func createDirectory(URL: NSURL, withIntermediateDirectories createIntermediates: Bool, attributes: [String: AnyObject]?, completion: ((success: Bool, error: NSError?) -> Void)) {
		do {
			try NSFileManager.defaultManager().createDirectoryAtPath(URL.path!, withIntermediateDirectories: createIntermediates, attributes: attributes)
			completion(success: true, error: nil)
		} catch let error as NSError {
			completion(success: false, error: error)
		}
	}
	
	/**
	:name:	removeDirectory
	*/
	public static func removeDirectory(path: NSURL, completion: ((success: Bool, error: NSError?) -> Void))  {
		do {
			try NSFileManager.defaultManager().removeItemAtURL(path)
			completion(success: true, error: nil)
		} catch let error as NSError {
			completion(success: false, error: error)
		}
	}
	
	/**
	:name:	contentsOfDirectory
	*/
	public static func contentsOfDirectory(path: NSURL, shouldSkipHiddenFiles skip: Bool = false, completion: ((contents: [NSURL]?, error: NSError?) -> Void)) {
		do {
			let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options: skip == true ? NSDirectoryEnumerationOptions.SkipsHiddenFiles : NSDirectoryEnumerationOptions(rawValue: 0))
			completion(contents: contents, error: nil)
		} catch let error as NSError {
			return completion(contents: nil, error: error)
		}
	}
	
	/**
	:name:	writeTo
	*/
	public static func writeTo(path: NSURL, value: String, name: String, completion: ((success: Bool, error: NSError?) -> Void)) {
		do{
			try value.writeToURL(path.URLByAppendingPathComponent("/\(name)"), atomically: true, encoding: NSUTF8StringEncoding)
			completion(success: true, error: nil)
		} catch let error as NSError {
			completion(success: false, error: error)
		}
	}
	
	/**
	:name:	readFrom
	*/
	public static func readFrom(path: NSURL, completion: ((string: String?, error: NSError?) -> Void)) {
		if let data = NSData(contentsOfURL: path) {
			completion(string: String(data: data, encoding: NSUTF8StringEncoding), error: nil)
		} else {
			completion(string: nil, error: NSError(domain: "io.graph.File", code: 0, userInfo: nil))
		}
	}
	
	/**
	:name:	URL
	*/
	public static func URL(searchPathDirectory: NSSearchPathDirectory, path: String) -> NSURL? {
		var URL: NSURL?
		switch searchPathDirectory {
		case .DocumentDirectory:
			URL = File.documentDirectoryPath
		case .LibraryDirectory:
			URL = File.libraryDirectoryPath
		case .CachesDirectory:
			URL = File.cachesDirectoryPath
		case .ApplicationSupportDirectory:
			URL = File.applicationSupportDirectoryPath
		default:
			URL = nil
			break
		}
		return URL?.URLByAppendingPathComponent(path)
	}
	
	/**
	:name: pathForDirectory
	*/
	public static func pathForDirectory(searchPath: NSSearchPathDirectory) -> NSURL? {
		return try? NSFileManager.defaultManager().URLForDirectory(searchPath, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
	}
	
	/**
	:name: fileType
	*/
	public static func fileType(URL: NSURL) -> FileType {
		var isDirectory: Bool = false
		File.contentsOfDirectory(URL) { (contents: [NSURL]?, error: NSError?) -> Void in
			if nil == error {
				return isDirectory = true
			}
		}
		if isDirectory {
			return .Directory
		}
		if let v: String = URL.pathExtension {
			switch v {
			case ImageExtensionToString(.PNG),
			ImageExtensionToString(.JPG),
			ImageExtensionToString(.JPEG),
			ImageExtensionToString(.GIF):
				return .Image
			case TextExtensionToString(.TXT),
			TextExtensionToString(.RTF),
			TextExtensionToString(.HTML):
				return .Text
			case VideoExtensionToString(.MOV),
			VideoExtensionToString(.M4V),
			VideoExtensionToString(.MP4):
				return .Video
			case SQLiteExtensionToString(.SQLite),
			SQLiteExtensionToString(.SQLiteSHM):
				return .SQLite
			default:
				break
			}
		}
		return .Unknown
	}
}