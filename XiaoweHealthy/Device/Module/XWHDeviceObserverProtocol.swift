//
//  XWHDeviceObserverProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/18.
//

import Foundation


protocol XWHDeviceObserverProtocol: AnyObject {
    
    func updateDeviceConnectBind()
    
    func updateSyncState(_ syncState: XWHDevDataTransferState)
    
}

extension XWHDeviceObserverProtocol {
    
    func updateSyncState(_ syncState: XWHDevDataTransferState) {
        
    }
    
}
