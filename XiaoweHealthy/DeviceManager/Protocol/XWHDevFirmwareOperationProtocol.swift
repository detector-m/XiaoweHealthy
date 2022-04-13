//
//  XWHDevFirmwareOperationProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation


// MARK: - 固件升级操作协议
protocol XWHDevFirmwareOperationProtocol {
    
    /// 发送固件文件
    /// - Parameters:
    ///     - fileUrl: 固件文件
    ///     - progressHandler: 进度回调结果
    ///     - handler: 操作回调结果
    func sendFirmwareFile(_ fileUrl: URL, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?)
    
}
