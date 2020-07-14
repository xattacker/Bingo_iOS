//
//  FileUtility.swift
//  UtilToolKit
//
//  Created by xattacker on 2015/11/27.
//  Copyright © 2015年 xattacker. All rights reserved.
//

import Foundation
import MobileCoreServices


let GB_SIZE = UInt64(1024 * 1024 * 1024)
let MB_SIZE = UInt64(1024 * 1024)
let KB_SIZE = UInt64(1024)


public enum FileType: Int
{
    case image   = 0
    case audio   = 1
    case video   = 2
    case html    = 3
    case pdf     = 4
    
    case others  = 99
    case unknown = 100
}


public final class FileUtility
{
    public class func getDiskSpace() -> (total: UInt64, free: UInt64)
    {
        var total_size: UInt64 = UInt64(0)
        var free_size: UInt64 = UInt64(0)
        
        do
        {
            let paths = NSSearchPathForDirectoriesInDomains(
                        FileManager.SearchPathDirectory.documentDirectory,
                        FileManager.SearchPathDomainMask.userDomainMask,
                        true)
            
            let dictionary = try FileManager.default.attributesOfFileSystem(forPath: paths.last!)
           
            if let total = dictionary[FileAttributeKey.systemSize] as? NSNumber
            {
                total_size = total.uint64Value
            }
            
            if let free = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber
            {
                free_size = free.uint64Value
            }
        }
        catch
        {
        }

        return (total_size, free_size)
    }
    
    public class func checkFileDuplicate(_ filePath: String) -> String
    {
        var new_file_path = filePath
        let fm = FileManager.default
        
        if fm.fileExists(atPath: filePath)
        {
            var index = 1
            var temp_path = ""
            
            autoreleasepool
            {
                let file_sub = filePath.stringByDeletingPathExtension
                let file_type = filePath.pathExtension
                
                repeat
                {
                    temp_path = ""
                    temp_path += file_sub ?? ""
                    temp_path += "("
                    temp_path += String(index)
                    temp_path += ")"
                    
                    if let file_type = file_type, file_type.length > 0
                    {
                        temp_path += "."
                        temp_path += file_type
                    }
                    
                    index += 1
                
                // max count is 99
                } while fm.fileExists(atPath: temp_path) && index <= 99
            }
            
            new_file_path = temp_path
        }
        
        return new_file_path
    }
    
    public class func checkFileType(_ fileName: String) -> FileType
    {
        var type = FileType.unknown
        
        if let type_name = fileName.pathExtension?.lowercased()
        {
            switch type_name
            {
                case "jpg", "jpge", "gif", "png", "bmp":
                    type = .image
                    break
                    
                case "mp3", "wav", "amr", "mid":
                    type = .audio
                    break
                    
                case "3gp", "mp4", "m4v", "mov":
                    type = .video
                    break
                    
                case "htm", "html":
                    type = .html
                    break
                    
                case "pdf":
                    type = .pdf
                    break
                    
                default:
                    type = .others
                    break
            }
        }
        
        return type
    }
    
    public class func isFileExisted(_ filePath: String?) -> Bool
    {
        var result = false
        
        if let filePath = filePath, filePath.length > 0
        {
            result = FileManager.default.fileExists(atPath: filePath)
        }
        
        return result
    }
    
    public class func isDirExisted(_ dirPath: String?) -> Bool
    {
        var result = ObjCBool(false)
        
        if let dirPath = dirPath, dirPath.length > 0
        {
            FileManager.default.fileExists(atPath: dirPath, isDirectory: &result)
        }
        
        return result.boolValue
    }
    
    public class func getFileSizeStr(_ byteSize: UInt64) -> String
    {
        var str: String = ""
        
        if byteSize >= GB_SIZE
        {
            let size = Double(byteSize) / Double(GB_SIZE)
            str = String(format: "%.2f GB", size)
        }
        else if byteSize >= MB_SIZE
        {
            let size = Double(byteSize) / Double(MB_SIZE)
            str = String(format: "%.2f MB", size)
        }
        else if byteSize >= KB_SIZE
        {
            let size = Double(byteSize) / Double(KB_SIZE)
            str = String(format: "%.2f KB", size)
        }
        else
        {
            str = String(format: "%llu Bytes", byteSize)
        }
        
        return str
    }
    
    public class func getFileSizeStr(_ filePath: String) -> String
    {
        var str: String = ""
        
        if self.isFileExisted(filePath)
        {
            do
            {
                let properties = try FileManager.default.attributesOfItem(atPath: filePath)
                if let size = (properties[FileAttributeKey.size] as? NSNumber)?.uint64Value
                {
                    str = self.getFileSizeStr(size)
                }
            }
            catch
            {
            }
        }
        
        return str
    }
    
    public class func getFileMimeType(_ filePath: String) -> String
    {
        // Borrowed from http://stackoverflow.com/questions/5996797/determine-mime-type-of-nsdata-loaded-from-a-file
        // itself, derived from  http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
        
        if let id = UTTypeCreatePreferredIdentifierForTag(
                    kUTTagClassFilenameExtension,
                    filePath.pathExtension! as CFString, nil)?.takeRetainedValue(),
           let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
        {
            return contentType as String
        }
        
        return "application/octet-stream"
    }
}


extension String
{
    public func checkFileType() -> FileType
    {
        return FileUtility.checkFileType(self)
    }
    
    public func getFileSizeStr() -> String
    {
        return FileUtility.getFileSizeStr(self)
    }
}
