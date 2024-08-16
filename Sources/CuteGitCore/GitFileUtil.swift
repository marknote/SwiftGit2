//
//  FileUtil.swift
//  MarkG
//
//  Created by Shumin Sun on 2024/5/11.
//

import Foundation

public struct GitFileUtil {
    public static func documentPath()->String {
        guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to find document directory")
        }
        
        return documentDirectoryURL.path
    }
    


    public static func ensurePath(_ path: String) {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        if !fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
                
            } catch let error as NSError {
                print("error ensurePath:\(path)\n\(error.localizedDescription)")
            }
        }
    }
    

    public static func fileExists(_ fullPath: String) -> Bool {
        let fm = FileManager.default
        var isDirectory: ObjCBool = false
        
        if fm.fileExists(atPath: fullPath, isDirectory: &isDirectory) {
            return !isDirectory.boolValue
        }
        
        return false
    }


    public static func lastModified(of path: String) -> Date? {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: path),
              let modificationDate = attrs[.modificationDate] as? Date else { return nil }
        return modificationDate
    }



    public static func readContent(fromTextFile sourceFilePath: String) -> String? {
            let fileURL = URL(fileURLWithPath: sourceFilePath)
            
            do {
                let content = try Data(contentsOf: fileURL)
                // Attempt to detect the encoding of the content
                // If you have a specific method to detect encoding, you can use it here
                // For simplicity, we're assuming UTF-8 encoding
                let convertedString = String(data: content, encoding: .utf8)
                return convertedString
            } catch {
                print("Error reading file: \(error)")
                return nil
            }
        }


}
