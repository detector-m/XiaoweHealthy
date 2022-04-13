//
//  XWHDevDialOperationProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation

typealias DialProgressHandler = (Int) -> Void


// MARK: - 设备表盘操作协议
protocol XWHDevDialOperationProtocol {
    
    /// 发送表盘数据
    /// - Parameters:
    ///     - data: 表盘数据
    ///     - progressHandler: 进度回调结果
    ///     - handler: 操作回调结果 (Result<XWHResponse?, XWHError>) XWHError.data = XWHDevDataProgressState
    func sendDialData(_ data: Data, progressHandler: DialProgressHandler?, handler: XWHDevCmdOperationHandler?)
    
    /// 发送表盘文件
    /// - Parameters:
    ///     - fileUrl: 表盘文件
    ///     - progressHandler: 进度回调结果
    ///     - handler: 操作回调结果
    func sendDialFile(_ fileUrl: URL, progressHandler: DialProgressHandler?, handler: XWHDevCmdOperationHandler?)
    
}
