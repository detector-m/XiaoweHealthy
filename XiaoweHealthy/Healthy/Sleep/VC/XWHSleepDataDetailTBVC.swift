//
//  XWHSleepDataDetailTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHSleepDataDetailTBVC: XWHHealthyDataDetailBaseTBVC {
    
    /// 所选的日期
//    lazy var sDate = Date()
    lazy var uiAllDataItemSleepModel = XWHSleepUIAllDataItemSleepModel()

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
        
        let sleepRateStrs = XWHUIDisplayHandler.getSleepRateStrings(uiAllDataItemSleepModel.deepSleepDuration, uiAllDataItemSleepModel.lightSleepDuration, uiAllDataItemSleepModel.awakeDuration, uiAllDataItemSleepModel.totalSleepDuration)
        
        if indexPath.row == 0 {
            titleStr = R.string.xwhHealthyText.睡眠总时长()
            valueStr = XWHUIDisplayHandler.getSleepDurationString(uiAllDataItemSleepModel.totalSleepDuration)
            cell.bottomLine.isHidden = false
        } else if indexPath.row == 1 {
            titleStr = R.string.xwhHealthyText.入睡时间()
            valueStr = uiAllDataItemSleepModel.bedTime
            cell.bottomLine.isHidden = false
        } else if indexPath.row == 2 {
            titleStr = R.string.xwhHealthyText.醒来时间()
            valueStr = uiAllDataItemSleepModel.riseTime
        } else if indexPath.row == 3 {
            titleStr = R.string.xwhHealthyText.深睡比例()
            valueStr = sleepRateStrs[0] + " " + XWHUIDisplayHandler.getDeepSleepRangeString(uiAllDataItemSleepModel.deepSleepDuration)
        } else if indexPath.row == 4 {
            titleStr = R.string.xwhHealthyText.浅睡比例()
            valueStr = sleepRateStrs[1] + " " + XWHUIDisplayHandler.getLightSleepRangeString(uiAllDataItemSleepModel.lightSleepDuration, uiAllDataItemSleepModel.totalSleepDuration)
        } else if indexPath.row == 5 {
            titleStr = R.string.xwhHealthyText.清醒时长()
            valueStr = XWHUIDisplayHandler.getSleepDurationString(uiAllDataItemSleepModel.awakeDuration) + " " + XWHUIDisplayHandler.getAwakeSleepRangeString(uiAllDataItemSleepModel.awakeDuration)
        } else if indexPath.row == 6 {
            titleStr = R.string.xwhHealthyText.来源()
            valueStr = uiAllDataItemSleepModel.deviceName
        }
        
        cell.titleLb.text = titleStr
        cell.subTitleLb.text = valueStr
        
        return cell
    }
    
}
