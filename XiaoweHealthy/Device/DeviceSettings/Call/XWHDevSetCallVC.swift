//
//  XWHDevSetCallVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetCallVC: XWHDevSetBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.来电提醒()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
        cell.titleLb.text = R.string.xwhDeviceText.来电提醒()
        cell.subTitleLb.text = R.string.xwhDeviceText.手机有来电时手表会同步震动提醒此功能需要设备和手机是连接状态且蓝牙是开启的()
        
        cell.clickAction = { isOn in
            if isOn {
                XWHAlert.show(title: R.string.xwhDeviceText.消息通知授权失败(), message: R.string.xwhDeviceText.这将导致部分功能无法正常使用您可到手机设置页面进行手动授权(), cancelTitle: R.string.xwhDeviceText.拒绝(), confirmTitle: R.string.xwhDeviceText.允许()) { cType in
                    if cType == .confirm {
                        log.debug("点击了允许")
                    }
                }
            }
        }
        
        return cell
    }

}
