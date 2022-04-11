//
//  XWHDeviceMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import SwiftyJSON

class XWHDeviceMainVC: XWHSearchBindDevBaseVC {
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    lazy var tableFooter = XWHDeviceMainFooter(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 32, height: 120)))
    
    private lazy var deviceItems = [[XWHDeployItemModel]]()
    
    private var connWatchModel: XWHDevWatchModel? {
        XWHDataDeviceManager.getCurrentWatch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configDeviceItems()
        reloadAll()
        
//        if var connWatch = XWHDataDeviceManager.getCurrentDeviceWatchModel() {
//            XWHDDMShared.config(device: connWatch)
////            XWHDDMShared.disconnect(device: connWatch)
//            XWHDDMShared.connect(device: connWatch, isReconnect: true) { [unowned self] (result: Result<XWHDeviceConnectState, XWHBLEError>, conState) in
//                switch result {
//                case .success(_):
//                    connWatch.isCurrent = true
//                    XWHDataDeviceManager.saveDeviceWatchModel(&connWatch)
//                    
//                case .failure(_):
//                    view.makeInsetToast("连接失败")
//                }
//            }
//        }
        
        getDeviceInfo()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        
        configTableView()
        view.addSubview(tableView)
        
        detailLb.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.我的设备()
        
        button.titleLabel?.font = UIFont.iconFont(size: 24)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(XWHIconFontOcticons.addCircle.rawValue, for: .normal)
        button.layer.backgroundColor = nil
        button.layer.cornerRadius = 0
    }
    
    override func relayoutSubViews() {
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.size.equalTo(24)
            make.top.equalToSuperview().offset(74)
        }
        
        titleLb.snp.makeConstraints { make in
            make.centerY.equalTo(button)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(button.snp.left)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

// MARK: - Config Data
extension XWHDeviceMainVC {
    
    private func configDeviceItems() {
        deviceItems = XWHDeviceDeploy().loadDeploys()
    }
    
    private func getDeviceInfo() {
        XWHDDMShared.getDeviceInfo { [unowned self] result in
            switch result {
            case .success(let cModel):
                if var connModel = cModel?.data as? XWHDevWatchModel, let curModel = XWHDataDeviceManager.getCurrentWatch() {
                    connModel.isCurrent = curModel.isCurrent
                    connModel.type = curModel.type
                    XWHDataDeviceManager.saveWatch(&connModel)
                    
                    reloadAll()
                }
                
            case .failure(let error):
                self.view.makeInsetToast(error.message)
            }
        }
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

// MARK: - UITableViewDataSource,
extension XWHDeviceMainVC: UITableViewDataSource, UITableViewDelegate, UITableViewRoundedProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return deviceItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceItems[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        if item.cellType == .info {
            return 209
        }
        
        if item.cellType == .dail {
            return 184
        }
            
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        if item.cellType == .info {
            let cell = tableView.dequeueReusableCell(withClass: XWHDeviceInfoTBCell.self)
            
            let tColor = UIColor(hex: 0x2A2A2A)!
            let txt1 = "SKYWORTH"
//            let txt2 = "Watch S1"
            let txt2 = connWatchModel?.name.replacingOccurrences(of: txt1, with: "") ?? ""
            let attr = "\(txt1) \(txt2)".colored(with: tColor).applying(attributes: [.font: XWHFont.skSans(ofSize: 13, weight: .bold)], toOccurrencesOf: txt1).applying(attributes: [.font: XWHFont.skSans(ofSize: 13, weight: .regular)], toOccurrencesOf: txt2)
            
            cell.titleLb.attributedText = attr
            cell.subTitleLb.text = "已连接  |  电量：\(connWatchModel?.battery ?? 0)%"
            
            return cell
        } else if item.cellType == .dail {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = UIColor(hex: 0xF8F8F8)
        
        return cView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        switch item.type {
        case .dialMarket:
            gotoDevSetDailMarket()
            
        case .chat:
            gotoDevSetChat()
            
        case .call:
            gotoDevSetCall()
            
        case .heart:
            gotoDevSetHeart()
            
        case .oxygen:
            gotoDevSetOxygen()
            
        case .stand:
            gotoDevSetStand()
            
        case .pressure:
            gotoDevSetWeather()
            
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
    
}

// MARK: - UI Jump
extension XWHDeviceMainVC {
    
    // 表盘市场
    private func gotoDevSetDailMarket() {
        view.makeInsetToast("功能开发中...")
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
    
    // 心率设置
    private func gotoDevSetHeart() {
        let vc = XWHDevSetHeartVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血氧饱和度设置
    private func gotoDevSetOxygen() {
        let vc = XWHDevSetOxygenVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 久坐提醒
    private func gotoDevSetStand() {
        let vc = XWHDevSetStandVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 压力设置
    private func gotoDevSetPressure() {
        let vc = XWHDevSetPressureVC()
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
                            XWHDataDeviceManager.deleteWatch(cModel)
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
        tableView.isUserInteractionEnabled = false
        XWHAlert.show(title: nil, message: R.string.xwhDeviceText.确认解除绑定的设备吗(), cancelTitle: R.string.xwhDisplayText.取消(), confirmTitle: R.string.xwhDeviceText.解除绑定()) { [unowned self] cType in
            self.tableView.isUserInteractionEnabled = true
            if cType == .confirm {
//                self.view.makeInsetToast("已经解除绑定")
                if let cModel = self.connWatchModel {
                    XWHDDMShared.disconnect(device: cModel)
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


// MARK: - Private Tools
extension XWHDeviceMainVC {
    
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
        }
    }
}
