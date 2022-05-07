//
//  XWHSleepDataDetailTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHSleepDataDetailTBVC: XWHHealthyDataDetailBaseTBVC {
    
    /// 所选的日期
    lazy var sDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHSleepDataDetailTBVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailTBCell.self, for: indexPath)
        cell.bottomLine.isHidden = true
        
        var titleStr = ""
        var valueStr = ""
        
        if indexPath.row == 0 {
            titleStr = R.string.xwhHealthyText.睡眠总时长()
            valueStr = XWHUIDisplayHandler.getSleepDurationString(500)
            cell.bottomLine.isHidden = false
        } else if indexPath.row == 1 {
            titleStr = R.string.xwhHealthyText.入睡时间()
            valueStr = Date().localizedString(withFormat: XWHDate.YearMonthDayHourMinuteFormat)
            cell.bottomLine.isHidden = false
        } else if indexPath.row == 2 {
            titleStr = R.string.xwhHealthyText.醒来时间()
            valueStr = Date().localizedString(withFormat: XWHDate.YearMonthDayHourMinuteFormat)
        } else if indexPath.row == 3 {
            titleStr = R.string.xwhHealthyText.深睡比例()
            valueStr = "27% 充足"
        } else if indexPath.row == 4 {
            titleStr = R.string.xwhHealthyText.浅睡比例()
            valueStr = "27% 充足"
        } else if indexPath.row == 5 {
            titleStr = R.string.xwhHealthyText.清醒时长()
            valueStr = "45 较长"
        } else if indexPath.row == 6 {
            titleStr = R.string.xwhHealthyText.来源()
            valueStr = "xxx"
        }
        
        cell.titleLb.text = titleStr
        cell.subTitleLb.text = valueStr
        
        return cell
    }
    
}
