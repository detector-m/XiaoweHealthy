//
//  XWHDevDataOperationProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation

typealias DevSyncDataProgressHandler = DevTransferProgressHandler

typealias XWHDevDataOperationHandler = (_ syncType: XWHDevSyncDataType, _ syncState: XWHDevDataTransferState, Result<XWHResponse?, XWHError>) -> Void


/// 设备数据处理（操作、同步）协议
protocol XWHDevDataOperationProtocol {
    
    /// 同步状态
    var state: XWHDevDataTransferState { get }
    
    /// 配置数据处理回调
    /// - Parameters:
    ///     - progressHandler: 进度回调
    ///     - resultHandler: 结果回调
    func setDataOperation(progressHandler: DevSyncDataProgressHandler?, resultHandler: XWHDevDataOperationHandler?)
    
    /// 重置配置数据处理
    func resetDataOperation()
    
    
    /// 同步数据
    func syncData()
    
}
