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
    
    func createFolder(at path: String) {
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                log.error("创建文件路径失败, error = \(error)")
            }
        }
    }
    
    func moveFile(at: String, to: String) -> String? {
        do {
            try fileManager.moveItem(atPath: at, toPath: to)
            return to
        } catch let error {
            log.error("文件移动失败 error = \(error)")
            return nil
        }
    }
    
}
