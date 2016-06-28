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
 *	*	Neither the name of CosmicMind nor the names of its
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

/// Video extension types.
public enum VideoExtension {
    case MOV
    case M4V
    case MP4
}

/**
 Converts the VideoExtension to a string.
 - Parameter type: A VideoExtension type.
 - Returns: A String representation of the VideoExtension.
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

/// Image extension types.
public enum ImageExtension {
    case PNG
    case JPG
    case JPEG
    case TIFF
    case GIF
}

/**
 Converts the ImageExtension to a string.
 - Parameter type: A ImageExtension type.
 - Returns: A String representation of the ImageExtension.
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

/// Text extension types.
public enum TextExtension {
    case TXT
    case RTF
    case HTML
}

/**
 Converts the TextExtension to a string.
 - Parameter type: A TextExtension type.
 - Returns: A String representation of the TextExtension.
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

/// SQLite extension types.
public enum SQLiteExtension {
    case SQLite
    case SQLiteSHM
}

/**
 Converts the SQLiteExtension to a string.
 - Parameter type: A SQLiteExtension type.
 - Returns: A String representation of the SQLiteExtension.
 */
public func SQLiteExtensionToString(type: SQLiteExtension) -> String {
    switch type {
    case .SQLite:
        return "sqlite"
    case .SQLiteSHM:
        return "sqlite-shm"
    }
}

/// Schemas used with Persistant Storage
public struct Schema {
    public static let File = "File://"
}

/// A result type.
public enum Result {
    case Success
    case Failure(error: NSError)
}

/// File types.
public enum FileType {
    case Directory
    case Image
    case Video
    case Text
    case SQLite
    case Unknown
}

public struct File {
    /// A reference to the DocumentDirectory.
    public static let documentDirectoryPath: NSURL? = File.pathForDirectory(.DocumentDirectory)
    
    /// A reference to the LibraryDirectory.
    public static let libraryDirectoryPath: NSURL? = File.pathForDirectory(.LibraryDirectory)
    
    /// A reference to the ApplicationSupportDirectory.
    public static let applicationSupportDirectoryPath: NSURL? = File.pathForDirectory(.ApplicationSupportDirectory)
    
    /// A reference to the CachesDirectory.
    public static let cachesDirectoryPath: NSURL? = File.pathForDirectory(.CachesDirectory)
    
    /// A reference to the rootPath.
    public static var rootPath: NSURL? {
        let path = File.documentDirectoryPath
        var pathComponents = path?.pathComponents
        pathComponents?.removeLast()
        return NSURL(string: Schema.File.stringByAppendingString((pathComponents?.joinWithSeparator("/"))!))
    }
    
    /**
     Checks whether a file exists at a given path.
     - Parameter path: A NSURL to check.
     - Returns: A boolean of the result, true if exists, false otherwise.
    */
    public static func fileExistsAtPath(path: NSURL) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path.path!)
    }
    
    /**
     Checks whether a two paths equal the same contents.
     - Parameter path: A NSURL to check.
     - Parameter andPath: A comparison path.
     - Returns: A boolean of the result, true if equal, false otherwise.
     */
    public static func contentsEqualAtPath(path: NSURL, andPath: NSURL) -> Bool {
        return NSFileManager.defaultManager().contentsEqualAtPath(path.path!, andPath: andPath.path!)
    }
    
    /**
     Checks whether a file is writable at a given path.
     - Parameter path: A NSURL to check.
     - Returns: A boolean of the result, true if writable, false otherwise.
     */
    public static func isWritableFileAtPath(path: NSURL) -> Bool {
        return NSFileManager.defaultManager().isWritableFileAtPath(path.path!)
    }
    
    /**
     Removes an item at a given path.
     - Parameter path: A NSURL to remove.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func removeItemAtPath(path: NSURL, completion: ((removed: Bool?, error: NSError?) -> Void)? = nil) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path.path!)
            completion?(removed: true, error: nil)
        } catch let e as NSError {
            completion?(removed: nil, error: e)
        }
    }
    
    /**
     Creates a directory at a given path.
     - Parameter path: A NSURL that indicates the directory path to create.
     - Parameter withIntermediateDirectories: To create intermediate directories.
     - Parameter attributes: Any additional attributes.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func createDirectoryAtPath(path: NSURL, withIntermediateDirectories createIntermediates: Bool, attributes: [String: AnyObject]?, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(path.path!, withIntermediateDirectories: createIntermediates, attributes: attributes)
            completion?(success: true, error: nil)
        } catch let e as NSError {
            completion?(success: false, error: e)
        }
    }
    
    /**
     Removes a directory at a given path.
     - Parameter path: A NSURL that indicates the directory path to remove.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func removeDirectoryAtPath(path: NSURL, completion: ((success: Bool, error: NSError?) -> Void)?  = nil)  {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(path)
            completion?(success: true, error: nil)
        } catch let e as NSError {
            completion?(success: false, error: e)
        }
    }
    
    /**
     Fetch the contents at a given path.
     - Parameter path: A NSURL that indicates the directory path to fetch.
     - Parameter shouldSkipHiddenFiles: A boolean to skip hidden files or not.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func contentsOfDirectoryAtPath(path: NSURL, shouldSkipHiddenFiles skip: Bool = false, completion: ((contents: [NSURL]?, error: NSError?) -> Void)) {
        do {
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options: skip == true ? NSDirectoryEnumerationOptions.SkipsHiddenFiles : NSDirectoryEnumerationOptions(rawValue: 0))
            completion(contents: contents, error: nil)
        } catch let e as NSError {
            return completion(contents: nil, error: e)
        }
    }
    
    /**
     Write to a given path.
     - Parameter path: A NSURL that indicates the directory to write to.
     - Parameter name: The path name to write at.
     - Parameter value: The value to write.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func writeToPath(path: NSURL, name: String, value: String, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        do{
            try value.writeToURL(path.URLByAppendingPathComponent("/\(name)"), atomically: true, encoding: NSUTF8StringEncoding)
            completion?(success: true, error: nil)
        } catch let e as NSError {
            completion?(success: false, error: e)
        }
    }
    
    /**
     Read from a given path.
     - Parameter path: A NSURL that indicates the directory to write to.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func readFromPath(path: NSURL, completion: ((string: String?, error: NSError?) -> Void)) {
        if let data = NSData(contentsOfURL: path) {
            completion(string: String(data: data, encoding: NSUTF8StringEncoding), error: nil)
        } else {
            completion(string: nil, error: NSError(domain: "io.graph.File", code: 0, userInfo: nil))
        }
    }
    
    /**
     Prepares a NSURL based on the given directory path.
     - Parameter searchPathDirectory: A search directory.
     - Parameter path: A given path to search from in the directory.
     - Returns: An optional NSURL to return if possible.
     */
    public static func path(searchPathDirectory: NSSearchPathDirectory, path: String) -> NSURL? {
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
     Fetches a path for a given search directory and creates it if
     it does not exist.
     - Parameter searchPathDirectory: A search directory.
     - Returns: An optional NSURL to return if possible.
     */
    public static func pathForDirectory(searchPathDirectory: NSSearchPathDirectory) -> NSURL? {
        return try? NSFileManager.defaultManager().URLForDirectory(searchPathDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
    /**
     Returns the FileType for a given path.
     - Parameter path: A search path.
     - Returns: An optional NSURL to return if possible.
     */
    public static func fileType(path: NSURL) -> FileType {
        var isDirectory = false
        File.contentsOfDirectoryAtPath(path) { (contents: [NSURL]?, error: NSError?) -> Void in
            isDirectory = nil == error
        }
        if isDirectory {
            return .Directory
        }
        if let v = path.pathExtension {
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