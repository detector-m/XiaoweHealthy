//
//  XWHDeviceMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import SwiftyJSON

class XWHDeviceMainVC: XWHTableViewBaseVC, XWHDeviceObserverProtocol {
    
//    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    lazy var tableFooter = XWHDeviceMainFooter(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 32, height: 120)))
    
    private lazy var deviceItems = [[XWHDeviceDeployItemModel]]()
    
    private var connWatchModel: XWHDevWatchModel? {
        XWHDataDeviceManager.getCurrentWatch()
    }
    
    deinit {
        XWHDevice.shared.removeObserver(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configDeviceItems()
        XWHDevice.shared.addObserver(observer: self)
        reloadAll()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)
        
        let leftItem = getNavItem(text: R.string.xwhDeviceText.我的设备(), font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
        navigationItem.leftBarButtonItem = leftItem
        
        let rightImage = UIImage.iconFont(text: XWHIconFontOcticons.addCircle.rawValue, size: 24, color: fontDarkColor)
        let rightItem = getNavItem(text: nil, image: rightImage, target: self, action: #selector(clickNavRightItem))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func clickNavLeftItem() {
        
    }
    
    @objc private func clickNavRightItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        // 大标题方式1
        setLargeTitleMode()
        
        // 大标题方式2
//        tableView.addSubview(largeTitleView)
//        setTopInsetForLargeTitle(in: tableView)
//        setLargeTitleMode()
        
        configLargeTitleView()
        configTableView()
    }
    
    override func relayoutSubViews() {
        // 大标题方式1
//         relayoutSubViewsOne()
        // 大标题方式2
        relayoutSubViewsTwo()
    }
    
    func configLargeTitleView() {
        largeTitleView.titleLb.text = R.string.xwhDeviceText.我的设备()
        largeTitleView.backgroundColor = collectionBgColor
        
        largeTitleView.button.titleLabel?.font = UIFont.iconFont(size: 24)
        largeTitleView.button.setTitleColor(UIColor.black, for: .normal)
        largeTitleView.button.setTitle(XWHIconFontOcticons.addCircle.rawValue, for: .normal)
        largeTitleView.button.layer.backgroundColor = nil
        largeTitleView.button.layer.cornerRadius = 0
    }
    
    func relayoutSubViewsOne() {
        relayoutLargeTitle()
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(largeTitleView.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitleContentViewOne()
    }
    func relayoutSubViewsTwo() {
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitle()
        
        relayoutLargeTitleContentViewTwo()
    }
    
    func relayoutLargeTitleContentViewOne() {
        largeTitleView.relayout { ltView in
            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().offset(16)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
            
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(-16)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }
        }
    }
    
    func relayoutLargeTitleContentViewTwo() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview()
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !XWHUser.isLogined() {
            gotoAddDeviceEntry()
            
            return
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate, UITableViewRoundedProtocol
    override func numberOfSections(in tableView: UITableView) -> Int {
        return deviceItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        if item.cellType == .info {
            return 209
        }
        
        if item.cellType == .dial {
            return 184
        }
            
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        if item.cellType == .info {
            let cell = tableView.dequeueReusableCell(withClass: XWHDeviceInfoTBCell.self)
            if let cDevModel = connWatchModel {
//                cell.update(cDevModel, isConnected: XWHDevice.shared.isConnectBind, isSyncing: XWHDevice.shared.isSyncing)
                
                cell.update(cDevModel, connectBindState: XWHDDMShared.connectBindState, isSyncing: XWHDevice.shared.isSyncing)
                
                cell.clickCallback = { [unowned self] in
                    self.gotoReconnectOrSyncData()
                }
            }
            
            return cell
        } else if item.cellType == .dial {
            let cell = tableView.dequeueReusableCell(withClass: XWHDialMarketTBCell.self)
            
            cell.titleLb.text = item.title
            cell.subTitleLb.text = item.subTitle
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDeviceNormallTBCell.self)
            
            cell.iconView.image = UIImage(named: item.iconImageName)
            cell.iconView.layer.backgroundColor = item.iconBgColor?.cgColor
            cell.titleLb.text = item.title
            cell.subTitleLb.text = item.subTitle
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = UIColor(hex: 0xF8F8F8)
        
        return cView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        if item.cellType == .info {
            return
        }

        if !XWHDevice.shared.isConnectBind {
            view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        if XWHDevice.shared.isSyncing {
            view.makeInsetToast(R.string.xwhDeviceText.同步中())
            return
        }
                
        switch item.type {
        case .dialMarket:
            gotoDevSetDialMarket()
            
        case .chat:
            gotoDevSetChat()
            
        case .call:
            gotoDevSetCall()
            
        case .contact:
            gotoDevSetContact()
            
        case .heart:
            gotoDevSetHeart()
            
        case .bloodOxygen:
            gotoDevSetBloodOxygen()
            
        case .stand:
            gotoDevSetStand()
            
        case .mentalStress:
            gotoDevSetMentalStress()
            
        case .weather:
            gotoDevSetWeather()
            
        case .wrist:
            gotoDevSetWrist()
            
        case .disturb:
            gotoDevSetDisturb()
            
            // 使用指南
        case .guide:
            gotoDevSetGuide()
            
            // 恢复出厂
        case .recover:
            gotoDevSetRecover()
            
            // 检查更新
        case .update:
            gotoCheckFirmwareUpdate()
            
        default:
            return
        }
    }
    
    // MARK: - UIScorllViewDelegate
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        handleScrollLargeTitle(in: scrollView)
//    }
    
    // MARK: - XWHDeviceObserverProtocol
    func updateDeviceConnectBind() {
        reloadAll()
    }

}

// MARK: - Config Data
extension XWHDeviceMainVC {
    
    private func configDeviceItems() {
        deviceItems = XWHDeviceDeploy().loadDeploys()
    }
    
}

// MARK: - ConfigUI
extension XWHDeviceMainVC {
    
    private func configTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
//        tableView.tableHeaderView = UIView()
//        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
//        tableView.isExclusiveTouch = true
        
        tableView.tableFooterView = tableFooter
        
        tableFooter.clickCallback = { [unowned self] in
            self.gotoDevSetUnbind()
        }
        
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDeviceInfoTBCell.self)
        
        tableView.register(cellWithClass: XWHDeviceNormallTBCell.self)
        tableView.register(cellWithClass: XWHDialMarketTBCell.self)
    }
    
}

// MARK: - UI
extension XWHDeviceMainVC {
    
    private func reloadAll() {
        configDeviceItems()
        tableView.reloadData()
    }
    
}

// MARK: - Api
extension XWHDeviceMainVC {
    
//    private func checkReconnect() {
//        if XWHDDMShared.connectBindState == .disconnected {
//            reconnect()
//        }
//    }
//
//    private func reconnect() {
//        if let connWatch = XWHDataDeviceManager.getCurrentWatch() {
//            XWHDDMShared.config(device: connWatch)
//            XWHDDMShared.reconnect(device: connWatch) { [weak self] (result: Result<XWHDeviceConnectBindState, XWHBLEError>) in
//                guard let self = self else {
//                    return
//                }
//
//                switch result {
//                case .success(let connBindState):
//                    if connBindState == .paired {
//                        self.updateDeviceInfo()
//                    } else {
//                        self.view.makeInsetToast("重连设备失败")
//                    }
//
//                case .failure(_):
//                    self.view.makeInsetToast("重连设备失败")
//                }
//            }
//        }
//    }
//
//    private func updateDeviceInfo() {
//        XWHDDMShared.getDeviceInfo { [unowned self] result in
//            switch result {
//            case .success(let cModel):
//                if let connModel = cModel?.data as? XWHDevWatchModel, let curModel = XWHDataDeviceManager.getCurrentWatch() {
//                    connModel.isCurrent = curModel.isCurrent
//                    connModel.type = curModel.type
//                    connModel.category = curModel.category
//                    XWHDataDeviceManager.setCurrent(device: connModel)
//
//                    reloadAll()
//                }
//
//            case .failure(let error):
//                self.view.makeInsetToast(error.message)
//            }
//        }
//    }
    
    private func gotoCheckFirmwareUpdate() {
        XWHDeviceVM().firmwareUpdate(deviceSn: "1923190012204123450", version: "v1.0.0") { [unowned self] error in
            self.view.makeInsetToast(error.message)
        } successHandler: { [unowned self] response in
            guard let cJson = response.data as? JSON else {
                self.view.makeInsetToast(R.string.xwhDeviceText.当前已经是最新版本())
                return
            }

            if let _ = cJson["fileUrl"].string {
                self.gotoDevSetUpdate(updateInfo: cJson)
            } else {
                self.view.makeInsetToast(R.string.xwhDeviceText.当前已经是最新版本())
            }
            
            // Test
//            self.gotoDevSetUpdate(updateInfo: JSON())
        }
    }
    
}

// MARK: - UI Jump
extension XWHDeviceMainVC {
    
    // 重连设备或者同步数据
    private func gotoReconnectOrSyncData() {
        if XWHDevice.shared.isConnectBind {
            if XWHDevice.shared.isSyncing {
                view.makeInsetToast(R.string.xwhDeviceText.同步中())
                return
            }
            
            XWHDevice.shared.syncData()
        } else {
            RLBLEPermissions.shared.getState { bleState in
                if bleState == .poweredOn {
                    XWHDevice.shared.connect()
                } else {
                    XWHAlert.show(message: R.string.xwhDeviceText.连接设备需要打开手机蓝牙要开启吗())
                }
            }
        }
    }
    
    // 表盘市场
    private func gotoDevSetDialMarket() {
        let vc = XWHDialVC()
        // Test
        vc.deviceSn = XWHHealthyMainVC.testDeviceSn()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 消息通知
    private func gotoDevSetChat() {
        let vc = XWHDevSetChatVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 来电提醒
    private func gotoDevSetCall() {
        let vc = XWHDevSetCallVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 联系人
    private func gotoDevSetContact() {
        let vc = XWHContactVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 心率设置
    private func gotoDevSetHeart() {
        let vc = XWHDevSetHeartVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血氧饱和度设置
    private func gotoDevSetBloodOxygen() {
        let vc = XWHDevSetBloodOxygenVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 久坐提醒
    private func gotoDevSetStand() {
        let vc = XWHDevSetStandVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血压设置
    private func gotoDevSetBloodPressure() {
        let vc = XWHDevSetBloodPressureVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 精神压力设置
    private func gotoDevSetMentalStress() {
        let vc = XWHDevSetMentalStressVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 天气推送
    private func gotoDevSetWeather() {
        let vc = XWHDevSetWeatherVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 抬腕亮屏
    private func gotoDevSetWrist() {
        let vc = XWHDevSetWristVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 勿扰模式
    private func gotoDevSetDisturb() {
        let vc = XWHDevSetDisturbVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 使用指南
    private func gotoDevSetGuide() {
        XWHSafari.present(at: self, urlStr: "https://www.baidu.com")
    }
    
    // 恢复出厂设置
    private func gotoDevSetRecover() {
        tableFooter.button.cancelTracking(with: nil)
//        tableFooter.button.touchesCancelled([UITouch()], with: nil)
        XWHAlert.show(title: R.string.xwhDeviceText.恢复出厂设置(), message: R.string.xwhDeviceText.恢复出厂设置后设备中的设置和运动健康数据将被清空您确定恢复吗(), cancelTitle: R.string.xwhDisplayText.取消(), confirmTitle: R.string.xwhDeviceText.恢复()) { [unowned self] cType in
            if cType == .confirm {
                XWHDDMShared.reset { result in
                    switch result {
                    case .success(_):
                        if let cModel = self.connWatchModel {
                            XWHDataDeviceManager.remove(device: cModel)
                        }
                        self.gotoAddDeviceEntry()
                        
                    case .failure(let error):
                        self.view.makeInsetToast(error.message)
                    }
                }
            }
        }
    }
    
    // 检查更新
    private func gotoDevSetUpdate(updateInfo: JSON) {
        let vc = XWHDevSetUpdateVC()
        vc.updateInfo = updateInfo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 解除绑定
    private func gotoDevSetUnbind() {
        if XWHDevice.shared.isSyncing {
            view.makeInsetToast(R.string.xwhDeviceText.同步中())
            return
        }
        
        tableView.isUserInteractionEnabled = false
        XWHAlert.show(title: nil, message: R.string.xwhDeviceText.确认解除绑定的设备吗(), cancelTitle: R.string.xwhDisplayText.取消(), confirmTitle: R.string.xwhDeviceText.解除绑定()) { [unowned self] cType in
            self.tableView.isUserInteractionEnabled = true
            if cType == .confirm {
//                self.view.makeInsetToast("已经解除绑定")
                if let cModel = self.connWatchModel {
                    XWHDDMShared.disconnect(device: cModel)
                    XWHDataDeviceManager.remove(device: cModel)
                    self.gotoAddDeviceEntry()
                }
            }
        }
    }
    
    // 去设备入口
    private func gotoAddDeviceEntry() {
        let vc = XWHAddDeviceEntryVC()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
