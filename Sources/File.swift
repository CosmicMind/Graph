/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
    case mov
    case m4v
    case mp4
}

/**
 Converts the VideoExtension to a string.
 - Parameter type: A VideoExtension type.
 - Returns: A String representation of the VideoExtension.
 */
public func VideoExtensionToString(_ type: VideoExtension) -> String {
    switch type {
    case .mov:
        return "mov"
    case .m4v:
        return "m4v"
    case .mp4:
        return "mp4"
    }
}

/// Image extension types.
public enum ImageExtension {
    case png
    case jpg
    case jpeg
    case tiff
    case gif
}

/**
 Converts the ImageExtension to a string.
 - Parameter type: A ImageExtension type.
 - Returns: A String representation of the ImageExtension.
 */
public func ImageExtensionToString(_ type: ImageExtension) -> String {
    switch type {
    case .png:
        return "png"
    case .jpg:
        return "jpg"
    case .jpeg:
        return "jpeg"
    case .tiff:
        return "tiff"
    case .gif:
        return "gif"
    }
}

/// Text extension types.
public enum TextExtension {
    case txt
    case rtf
    case html
}

/**
 Converts the TextExtension to a string.
 - Parameter type: A TextExtension type.
 - Returns: A String representation of the TextExtension.
 */
public func TextExtensionToString(_ type: TextExtension) -> String {
    switch type {
    case .txt:
        return "txt"
    case .rtf:
        return "rtf"
    case .html:
        return "html"
    }
}

/// SQLite extension types.
public enum SQLiteExtension {
    case sqLite
    case sqLiteSHM
}

/**
 Converts the SQLiteExtension to a string.
 - Parameter type: A SQLiteExtension type.
 - Returns: A String representation of the SQLiteExtension.
 */
public func SQLiteExtensionToString(_ type: SQLiteExtension) -> String {
    switch type {
    case .sqLite:
        return "sqlite"
    case .sqLiteSHM:
        return "sqlite-shm"
    }
}

/// Schemas used with Persistant Storage
public struct Schema {
    public static let File = "File://"
}

/// File types.
public enum FileType {
    case directory
    case image
    case video
    case text
    case sqLite
    case unknown
}

public struct File {
    /// A reference to the DocumentDirectory.
    public static let documentDirectoryPath: URL? = File.pathForDirectory(.documentDirectory)

    /// A reference to the LibraryDirectory.
    public static let libraryDirectoryPath: URL? = File.pathForDirectory(.libraryDirectory)

    /// A reference to the ApplicationSupportDirectory.
    public static let applicationSupportDirectoryPath: URL? = File.pathForDirectory(.applicationSupportDirectory)

    /// A reference to the CachesDirectory.
    public static let cachesDirectoryPath: URL? = File.pathForDirectory(.cachesDirectory)

    /// A reference to the rootPath.
    public static var rootPath: URL? {
        let path = File.documentDirectoryPath
        var pathComponents = path?.pathComponents
        pathComponents?.removeLast()
        return URL(string: Schema.File + (pathComponents?.joined(separator: "/"))!)
    }

    /**
     Checks whether a file exists at a given path.
     - Parameter path: A NSURL to check.
     - Returns: A boolean of the result, true if exists, false otherwise.
     */
    public static func fileExistsAtPath(_ path: URL) -> Bool {
        return FileManager.default.fileExists(atPath: path.path)
    }

    /**
     Checks whether a two paths equal the same contents.
     - Parameter path: A NSURL to check.
     - Parameter andPath: A comparison path.
     - Returns: A boolean of the result, true if equal, false otherwise.
     */
    public static func contentsEqualAtPath(_ path: URL, andPath: URL) -> Bool {
        return FileManager.default.contentsEqual(atPath: path.path, andPath: andPath.path)
    }

    /**
     Checks whether a file is writable at a given path.
     - Parameter path: A NSURL to check.
     - Returns: A boolean of the result, true if writable, false otherwise.
     */
    public static func isWritableFileAtPath(_ path: URL) -> Bool {
        return FileManager.default.isWritableFile(atPath: path.path)
    }

    /**
     Removes an item at a given path.
     - Parameter path: A NSURL to remove.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func removeItemAtPath(_ path: URL, completion: ((Bool?, Error?) -> Void)? = nil) {
        do {
            try FileManager.default.removeItem(atPath: path.path)
            completion?(true, nil)
        } catch let e as NSError {
            completion?(nil, e)
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
    public static func createDirectoryAtPath(_ path: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?, completion: ((Bool, Error?) -> Void)? = nil) {
        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: createIntermediates, attributes: attributes)
            completion?(true, nil)
        } catch let e as NSError {
            completion?(false, e)
        }
    }

    /**
     Removes a directory at a given path.
     - Parameter path: A NSURL that indicates the directory path to remove.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func removeDirectoryAtPath(_ path: URL, completion: ((Bool, Error?) -> Void)?  = nil)  {
        do {
            try FileManager.default.removeItem(at: path)
            completion?(true, nil)
        } catch let e as NSError {
            completion?(false, e)
        }
    }

    /**
     Fetch the contents at a given path.
     - Parameter path: A NSURL that indicates the directory path to fetch.
     - Parameter shouldSkipHiddenFiles: A boolean to skip hidden files or not.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func contentsOfDirectoryAtPath(_ path: URL, shouldSkipHiddenFiles skip: Bool = false, completion: (([URL]?, Error?) -> Void)) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: skip == true ? FileManager.DirectoryEnumerationOptions.skipsHiddenFiles : FileManager.DirectoryEnumerationOptions(rawValue: 0))
            completion(contents, nil)
        } catch let e as NSError {
            return completion(nil, e)
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
    public static func writeToPath(_ path: URL, name: String, value: String, completion: ((Bool, Error?) -> Void)? = nil) {
        do{
            try value.write(to: path.appendingPathComponent("/\(name)"), atomically: true, encoding: String.Encoding.utf8)
            completion?(true, nil)
        } catch let e as NSError {
            completion?(false, e)
        }
    }

    /**
     Read from a given path.
     - Parameter path: A NSURL that indicates the directory to write to.
     - Parameter completion: An optional completion block when the operation
     is done.
     */
    public static func readFromPath(_ path: URL, completion: ((String?, Error?) -> Void)) {
        if let data = try? Data(contentsOf: path) {
            completion(String(data: data, encoding: String.Encoding.utf8), nil)
        } else {
            completion(nil, NSError(domain: "com.cosmicmind.Graph.File", code: 0, userInfo: nil))
        }
    }

    /**
     Prepares a NSURL based on the given directory path.
     - Parameter searchPathDirectory: A search directory.
     - Parameter path: A given path to search from in the directory.
     - Returns: An optional NSURL to return if possible.
     */
    public static func path(_ searchPathDirectory: FileManager.SearchPathDirectory, path: String) -> URL? {
        var url: URL?
        switch searchPathDirectory {
        case .documentDirectory:
            url = File.documentDirectoryPath
        case .libraryDirectory:
            url = File.libraryDirectoryPath
        case .cachesDirectory:
            url = File.cachesDirectoryPath
        case .applicationSupportDirectory:
            url = File.applicationSupportDirectoryPath
        default:
            url = nil
            break
        }
        return url?.appendingPathComponent(path)
    }

    /**
     Fetches a path for a given search directory and creates it if
     it does not exist.
     - Parameter searchPathDirectory: A search directory.
     - Returns: An optional NSURL to return if possible.
     */
    public static func pathForDirectory(_ searchPathDirectory: FileManager.SearchPathDirectory) -> URL? {
        return try? FileManager.default.url(for: searchPathDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }

    /**
     Returns the FileType for a given path.
     - Parameter path: A search path.
     - Returns: An optional NSURL to return if possible.
     */
    public static func fileType(_ path: URL) -> FileType {
        var isDirectory = false
        File.contentsOfDirectoryAtPath(path) { (contents: [URL]?, error: Error?) -> Void in
            isDirectory = nil == error
        }

        if isDirectory {
            return .directory
        }

        switch path.pathExtension {
        case ImageExtensionToString(.png),
             ImageExtensionToString(.jpg),
             ImageExtensionToString(.jpeg),
             ImageExtensionToString(.gif):
            return .image
        case TextExtensionToString(.txt),
             TextExtensionToString(.rtf),
             TextExtensionToString(.html):
            return .text
        case VideoExtensionToString(.mov),
             VideoExtensionToString(.m4v),
             VideoExtensionToString(.mp4):
            return .video
        case SQLiteExtensionToString(.sqLite),
             SQLiteExtensionToString(.sqLiteSHM):
            return .sqLite
        default:break
        }

        return .unknown
    }
}
