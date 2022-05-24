//
//  XWHDeviceUseGuideTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/24.
//

import UIKit

class XWHDeviceUseGuideTBVC: XWHDeviceConnectBindHelpTBVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        largeTitleView.titleLb.text = R.string.xwhDeviceText.使用指南()
    }
    
    override func configQuestions() {
        questions = [
            ["1、抬腕不亮屏", "解决方案：重新设置一下"],
            ["2、手表无法绑定支付宝", "无法绑定支付宝一般是由于网络原因，或者是手机与手表蓝牙连接异常。"],
        ]
        expandStates = questions.map({ _ in false })
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHDeviceUseGuideTBVC {

    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}


