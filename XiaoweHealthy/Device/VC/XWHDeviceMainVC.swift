//
//  XWHDeviceMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import SwiftyJSON
import CoreBluetooth

class XWHDeviceMainVC: XWHTableViewBaseVC {
    
//    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var topContentInset: CGFloat {
        66
    }
    
    lazy var tableFooter = XWHDeviceMainFooter(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 32, height: 120)))
    
    private lazy var deviceItems = [[XWHDeviceDeployItemModel]]()
    
    private var connWatchModel: XWHDevWatchModel? {
        XWHDeviceDataManager.getCurrentWatch()
    }
    
    lazy var dials = [XWHDialModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configDeviceItems()
        
        XWHDDMShared.addMonitorDelegate(self)
        
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
        
        setNavHidden(false, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    @objc private func clickNavLeftItem() {
        
    }
    
    @objc private func clickNavRightItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        setNavHidden(true, animated: true, async: isFirstTimeSetNavHidden)
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
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isBeingPresented || isMovingToParent {
            // push / present
        } else {
            // pop /dismiss to here
        }
        
        if !XWHUser.isLogined {
            gotoAddDeviceEntry()
            
            return
        }
        
        tableView.reloadData()
        
        getDials()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let vcs = navigationController?.viewControllers, !vcs.contains(self) {
            XWHDDMShared.removeMonitorDelegate(self)
        }
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
            if dials.isEmpty {
                return 74
            }
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
                cell.update(cDevModel, connectBindState: XWHDDMShared.connectBindState, isSyncing: XWHDevice.shared.isSyncing)
                
                cell.clickCallback = { [unowned self] in
                    self.gotoReconnectOrSyncData()
                }
            }
            
            return cell
        } else if item.cellType == .dial {
            let cell = tableView.dequeueReusableCell(withClass: XWHDialMarketTBCell.self)
            
            cell.update(title: item.title, subTitle: item.subTitle, dials: dials)
            
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
            view.makeInsetToast(R.string.xwhDeviceText.正在同步数据())
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
    
}

// MARK: - XWHMonitorFromDeviceProtocol
extension XWHDeviceMainVC: XWHMonitorFromDeviceProtocol {
    
    func receiveBLEState(_ state: CBManagerState) {
        
    }
    
    func receiveConnectInfo(device: XWHDevWatchModel, connectState: XWHDeviceConnectBindState, error: XWHBLEError?) {
        reloadAll()
    }

    func receiveSyncDataStateInfo(syncState: XWHDevDataTransferState, progress: Int, error: XWHError?) {
        if syncState == .succeed {
            XWHDevice.shared.updateDeviceInfo(completion: nil)
            view.makeInsetToast(R.string.xwhDeviceText.同步成功())
        } else if syncState == .failed {
            view.makeInsetToast(R.string.xwhDeviceText.同步失败())
        }
        
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
    
    private func getDials() {
        guard var deviceSn = connWatchModel?.identifier else {
            return
        }
        deviceSn = XWHDeviceHelper.getStandardDeviceSn(deviceSn)
        
        XWHDialVM().getMyDial(deviceSn: deviceSn) { [weak self] error in
            guard let self = self else {
                return
            }
            
            self.dials = []
            self.tableView.reloadData()
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let cDials = response.data as? [XWHDialModel] else {
                self.view.makeInsetToast("数据解析错误")
                return
            }
            
            self.dials = cDials
            self.tableView.reloadData()
        }
    }
    
    private func unbindDeviceToServer() {
        guard var deviceSn = connWatchModel?.identifier else {
            return
        }
        deviceSn = XWHDeviceHelper.getStandardDeviceSn(deviceSn)
        
        XWHUserVM().unbindDevice(deviceSn: deviceSn)
    }
    
    private func gotoCheckFirmwareUpdate() {
//        let deviceSn = "1923190012204123450"
//        let firmwareVersion = "v1.0.0"
        
//        let rawData = [
//            "versionNo": "v1.0.1",
//            "versionDesc": "这是最新版本",
//            "publishDate": "2022-03-29",
//            "fileUrl": "https://ycyoss.xiaowe.cc/dial/D3923001/D392301_pix360x360_rgb565.bin"
//        ]
//
//        let cJson = JSON(rawData)
//        gotoDevSetUpdate(updateInfo: cJson)
        
        guard var deviceSn = connWatchModel?.identifier, let firmwareVersion = connWatchModel?.version else {
            return
        }
        deviceSn = XWHDeviceHelper.getStandardDeviceSn(deviceSn)

        XWHDeviceVM().firmwareUpdate(deviceSn: deviceSn, version: firmwareVersion) { [weak self] error in
            guard let self = self else {
                return
            }
            
            self.view.makeInsetToast(error.message)
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let cJson = response.data as? JSON else {
                self.view.makeInsetToast(R.string.xwhDeviceText.当前已经是最新版本())
                return
            }

            if let _ = cJson["fileUrl"].string {
                self.gotoDevSetUpdate(updateInfo: cJson)
            } else {
                self.view.makeInsetToast(R.string.xwhDeviceText.当前已经是最新版本())
            }
        }
    }
    
}

// MARK: - UI Jump
extension XWHDeviceMainVC {
    
    // 重连设备或者同步数据
    private func gotoReconnectOrSyncData() {
        if XWHDevice.shared.isConnectBind {
            if XWHDevice.shared.isSyncing {
                view.makeInsetToast(R.string.xwhDeviceText.正在同步数据())
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
        // Test
//        let deviceSn = XWHHealthyMainVC.testDeviceSn()
        guard var deviceSn = connWatchModel?.identifier else {
            return
        }
        deviceSn = XWHDeviceHelper.getStandardDeviceSn(deviceSn)
                
        let vc = XWHDialVC()
        vc.deviceSn = deviceSn
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
        let vc = XWHDeviceUseGuideTBVC()
        navigationController?.pushViewController(vc, animated: true)
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
//                        if let cModel = self.connWatchModel {
//                            XWHDeviceDataManager.remove(device: cModel)
//                            self.unbindDeviceToServer()
//                        }
//                        self.gotoAddDeviceEntry()
                        self.view.makeInsetToast(R.string.xwhDeviceText.恢复出厂设置成功())
                        
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
            view.makeInsetToast(R.string.xwhDeviceText.正在同步数据())
            return
        }
        
        tableView.isUserInteractionEnabled = false
        XWHAlert.show(title: nil, message: R.string.xwhDeviceText.确认解除绑定的设备吗(), cancelTitle: R.string.xwhDisplayText.取消(), confirmTitle: R.string.xwhDeviceText.解除绑定()) { [unowned self] cType in
            self.tableView.isUserInteractionEnabled = true
            if cType == .confirm {
//                self.view.makeInsetToast("已经解除绑定")
                if let cModel = self.connWatchModel {
                    XWHDDMShared.disconnect(device: cModel)
                    XWHDeviceDataManager.remove(device: cModel)
                    
                    self.unbindDeviceToServer()
                    
                    self.gotoAddDeviceEntry()
                }
            }
        }
    }
    
    // 去设备入口
    private func gotoAddDeviceEntry() {
        let vc = XWHAddDeviceEntryVC()
        XWHDDMShared.removeMonitorDelegate(self)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
