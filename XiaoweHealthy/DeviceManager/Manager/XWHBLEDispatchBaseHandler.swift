//
//  XWHBLEDispatchBaseHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import UIKit

class XWHBLEDispatchBaseHandler: NSObject, XWHBLEDispatchProtocol {
    
    /// 配对方式
    var pairMode: XWHDevicePairMode = .search
//    var randomCode = ""

    /// 连接状态
    var connectBindState: XWHDeviceConnectBindState = .disconnected
    
    /// 是否是重连
    var isReconnect = false
    
    var monitorHandler: XWHDeviceMonitorHandler?
    
    var scanProgressHandler: XWHDevScanProgressHandler?
    var connectHandler: XWHDevConnectHandler?
    var bindHandler: XWHDevBindHandler?
    
    var cmdHandler: XWHDevCmdOperationProtocol?
    
    /// 数据处理handler
    var dataHandler: XWHDevDataOperationProtocol?
    
    var bleDevModel: XWHDevWatchModel?
//    var connectDevModel: XWHDevWatchModel?
    
    // MARK: - 基类计时器等
    ///扫描计时器
    fileprivate var _scanTimer: Timer?
    /// 连接计时器
    var connectTimer: Timer?
    /// 绑定计时器
    var bindTimer: Timer?
    
    /// 是否搜索成功
    var isSearchSuccess = false
    
    // MARK: - 私有定义
    /// 搜索设备超时时间
    fileprivate let searchTime: TimeInterval = 5
    
    /// 连接设备超时时间
    var connectTimeoutTime: TimeInterval {
        return 30
    }
    
    /// 绑定设备超时时间
    class var bindTimeoutTime: TimeInterval {
        return 30
    }
    
    /// 设置设备连接状态监听回调
    func setMonitorHandler(device: XWHDevWatchModel?, monitorHandler: XWHDeviceMonitorHandler?) {
        self.monitorHandler = monitorHandler
    }
    
//    func configCurType(type: XWHDeviceType) {
//        if curType != type {
//            DDLogDebug("configCurType 当前curType \(curType) || 将要替换为type \(type)")
//            curType = type
//        }
//    }
    
    
    // MARK: - 扫描
    // 开始扫描
    func startScan(device: XWHDevWatchModel, pairMode: XWHDevicePairMode, randomCode: String, progressHandler: XWHDevScanProgressHandler? = nil, scanHandler: XWHDevScanHandler?) {
        bleDevModel = device
        self.pairMode = pairMode;
//        self.randomCode = randomCode;
        
        //此处子类调用，可以回调，sdkDeviceToHBDevice子类分别调用的，无须担心
        log.debug("扫描创建计时器")

        scanTimerInvalidate()
        _scanTimer = Timer.scheduledTimer(withTimeInterval: searchTime, repeats: false, block: { [unowned self] cTimer in
            log.debug("扫描计时器\(self.searchTime)s，刷新回调")
            
            self.stopScan()

            let devices = self.sdkDeviceToXWHDevice()
            
            var response: Result<[XWHDevWatchModel], XWHBLEError> = .failure(XWHBLEError.normal)
            if devices.isEmpty {
                self.isSearchSuccess = false
            } else {
                self.isSearchSuccess = true
                response = .success(devices)
            }
            
            DispatchQueue.main.async {
                scanHandler?(response)
            }
        })
    }
  
    // 停止扫描
    func stopScan() {
        log.debug("扫描停止，计时器销毁")
        scanTimerInvalidate()
    }
    
    // MARK: - 连接
    func connect(device: XWHDevWatchModel, isReconnect: Bool, connectHandler: XWHDevConnectHandler?) {
        connectTimerInvalidate()
        bindTimerInvalidate()
        
        self.connectHandler = nil
        bindHandler = nil
        
        self.isReconnect = isReconnect
        
        self.connectHandler = connectHandler
        
        bleDevModel = device
        
        connectTimer = Timer.scheduledTimer(timeInterval: connectTimeoutTime, target: self, selector: #selector(connectTimeout), userInfo: nil, repeats: false)

        RunLoop.current.add(connectTimer!, forMode: .common)
    }

    /// 断开连接
    func disconnect(device: XWHDevWatchModel?) {
        
    }
    
    /// 连接超时
    /// - 连接超时处理
    @objc func connectTimeout() {
        bleDevModel = nil
        //TODO:这段代码进行一次调整，此处不应直接发Post
        if self.connectBindState == .connected {
            return
        }

        log.error("-----------连接手表超时-----------")
        connectBindState = .disconnected

        connectHandler?(.failure(.normal))
        connectHandler = nil
        
//        let cState = connectState
//        let dic = [connectState: "state"]
        
//        bleNotice.post(name: ConnectStateChanged, object: dic)
    }
    
    /// 重连设备
    func reconnect(device: XWHDevWatchModel, connectHandler: XWHDevConnectHandler?) {
        
    }
    
    // MARK: - 绑定
    func bind(device: XWHDevWatchModel?, bindHandler: XWHDevBindHandler?) {
        
    }
    
    /// 绑定超时
    /// - 绑定超时处理
    @objc func bindTimeout() {
        log.error("-----------绑定设备超时-----------")
        
        bindHandler?(.failure(.normal))
        bindHandler = nil
    }
    
    // 取消配对
    func unpair(device: XWHDevWatchModel?) {
        
    }
    
    /// 解除绑定
    func unbind(device: XWHDevWatchModel?, unbindHandler: XWHDevBindHandler?) {
        
    }
    
    /// 切换解绑
    func switchUnbind(handler: XWHDevBindHandler?) {
        
    }
    
    // MARK: - -------- 模型转换 --------
    /// SDK设备模型转XWH设备模型
    func sdkDeviceToXWHDevice() -> [XWHDevWatchModel] {
        return []
    }
    
    // MARK: - Private
    private func scanTimerInvalidate() {
        _scanTimer?.invalidate()
        _scanTimer = nil
    }
    
    // 关闭连接的计时器
    func connectTimerInvalidate() {
        connectTimer?.invalidate()
        connectTimer = nil
    }
    
    // 关闭绑定定时器
    func bindTimerInvalidate() {
        bindTimer?.invalidate()
        bindTimer = nil
    }
    
}
