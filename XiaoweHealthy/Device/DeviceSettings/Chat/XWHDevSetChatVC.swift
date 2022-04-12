//
//  XWHDevSetChatVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetChatVC: XWHDevSetBaseVC {
    
    private static var isShowAlert = true
    
    private lazy var chatItems = [XWHDevSetChatDeployItemModel]()
    
    private var isChatOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.消息通知()
    
        reloadAll()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(headerFooterViewClassWith: XWHTBHeaderFooterBaseView.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isChatOn {
           return 2
        }
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return chatItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 72
        }
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)

        if section == 0 {
            cell.relayoutTitleSubTitleLb()
            
            cell.titleLb.text = R.string.xwhDeviceText.消息通知()
            cell.subTitleLb.text = R.string.xwhDeviceText.开启后设备将接收手机的通知消息()
            cell.button.isSelected = isChatOn
        } else {
            let item = chatItems[row]
                        
            cell.relayoutTitleLb()
            
            cell.titleLb.text = item.title
            cell.button.isSelected = item.isOn
        }
        
        cell.clickAction = { [unowned self] isOn in
            if section == 0 {
                self.gotoSetChat(isOn: isOn)
            } else {
                self.gotoSetChatItem(at: row, isOn: isOn)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        
        return 16
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return super.tableView(tableView, viewForHeaderInSection: section)
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withClass: XWHTBHeaderFooterBaseView.self)
        
        headerView.titleLb.text = R.string.xwhDeviceText.选择在设备中接收消息的应用()
        
        return headerView
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            return
//        }
//    }
    
}

// MARK: - Config Data
extension XWHDevSetChatVC {
    
    private func configChatItems() {
        chatItems = XWHDevSetChartDeploy().loadDeploys()
    }
    
}

// MARK: - UI
extension XWHDevSetChatVC {
    
    private func reloadAll() {
        configChatItems()
        tableView.reloadData()
    }
    
}

// MARK: - UI
extension XWHDevSetChatVC {
    
    private func gotoSetChat(isOn: Bool) {
        let noticeSet = XWHNoticeSetModel()
        noticeSet.isOn = isOn
        
        setNoticeSet(noticeSet) { [unowned self] in
            self.isChatOn = isOn
//            if isOn {
//                self.gotoTurnOnChat()
//            } else {
//                self.tableView.reloadData()
//            }
            self.tableView.reloadData()
        }
    }
    private func gotoTurnOnChat() {
        XWHAlert.show(title: R.string.xwhDeviceText.消息通知授权失败(), message: R.string.xwhDeviceText.这将导致部分功能无法正常使用您可到手机设置页面进行手动授权(), confirmTitle: R.string.xwhDeviceText.去授权()) { cType in
            if cType == .confirm {
                log.debug("点击了去授权")
                self.tableView.reloadData()
            }
        }
    }
    
    private func gotoSetChatItem(at row: Int, isOn: Bool) {
        let item = chatItems[row]
        item.isOn = isOn
        if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 1)) as? XWHDevSetSwitchTBCell {
            cell.button.isSelected = isOn
        }
        if item.type == .message {
            if Self.isShowAlert {
                XWHAlert.show(message: R.string.xwhDeviceText.在手机通知栏显示的消息才能推送到设备上哦(), cancelTitle: nil, confirmTitle: R.string.xwhDeviceText.知道了())
                
                Self.isShowAlert = false
            }
        }
    }
    
}

// MARK: - Api
extension XWHDevSetChatVC {
    
    private func setNoticeSet(_ noticeSet: XWHNoticeSetModel, _ completion: (() -> Void)?) {
        XWHDDMShared.setNoticeSet(noticeSet) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                completion?()
                
            case .failure(let error):
                self.view.makeInsetToast(error.message)
            }
        }
    }
    
}
