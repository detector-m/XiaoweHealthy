//
//  XWHInnerDataHandlerProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/4.
//

import Foundation


/// 内部的同步数据的处理协议
protocol XWHInnerDataHandlerProtocol {
    
    /// 原始数据处理
    /// - Parameters:
    ///     - rawData: 原始数据
    ///     - type: 数据类型
    /// - Returns: 处理后的数据
    func handleRawData(_ rawData: Any?, type: XWHDevSyncDataType) -> Any?
    
    /// 原始数据处理
    /// - Parameters:
    ///     - error: 原始错误信息
    func handleError(_ error: Error?)
    
}
