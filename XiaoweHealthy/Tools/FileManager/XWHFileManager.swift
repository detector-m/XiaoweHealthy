//
//  XWHFileManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation
//import FilesProvider


class XWHFileManager {
    
    var fileManager: FileManager {
        FileManager.default
    }
    
    func exist(at path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    @discardableResult
    func createFolder(at path: String) -> Bool {
        if !exist(at: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                
                return true
            } catch let error {
                log.error("创建文件路径失败, error = \(error)")
                
                return false
            }
        }
        
        return true
    }
    
    @discardableResult
    func moveFile(at: String, to: String) -> String? {
        do {
            try fileManager.moveItem(atPath: at, toPath: to)
            return to
        } catch let error {
            log.error("文件移动失败 error = \(error)")
            return nil
        }
    }
    
    @discardableResult
    func deleteFile(at: String) -> Bool {
        if !exist(at: at) {
            do {
                try fileManager.removeItem(atPath: at)
                
                return true
            } catch let error {
                log.error("文件删除失败 error = \(error)")
                return false
            }
        }
        
        return true
    }
    
}
