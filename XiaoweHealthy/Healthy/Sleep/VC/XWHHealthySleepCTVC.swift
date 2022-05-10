//
//  XWHHealthySleepCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHHealthySleepCTVC: XWHHealthyBaseCTVC {
    
    override var popMenuItems: [String] {
        [R.string.xwhDeviceText.压力设置(), R.string.xwhHealthyText.所有数据()]
    }
    
    var sleepUIModel: XWHHealthySleepUISleepModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = R.string.xwhHealthyText.睡眠()
        
        getSleepExistDate()
        getSleep()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHSleepDayChartCTCell.self)
        
        collectionView.register(cellWithClass: XWHSleepCommonCTCell.self)
        collectionView.register(cellWithClass: XWHSleepScoreCTCell.self)
        
        collectionView.register(cellWithClass: XWHMultiColorLinearCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHHealthyCTReusableView.self)
    }
    
    override func clickDateBtn() {
        showCalendar() { [unowned self] scrollDate, cDateType in
            self._getSleepExistDate(scrollDate, sDateType: cDateType) { isExist in
            }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
        getSleepExistDate()
        getSleep()
        
        collectionView.reloadData()
    }
    
    func loadUIItems() {
        uiManager.loadItems(.sleep)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.cleanItems(without: [.chart])
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthySleepCTVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return uiManager.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = uiManager.items[section]
        if item.uiCardType == .chart {
            return 1
        }
        if item.uiCardType == .curDatas {
            return 1
        }
        
        if item.uiCardType == .sleepRange {
            return 5
        }
        
        return 0
    }
    
    // - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .chart {
            return CGSize(width: collectionView.width, height: 370)
        }
        
        if item.uiCardType == .curDatas {
            return CGSize(width: collectionView.width, height: 232)
        }
        
        if item.uiCardType == .sleepRange {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.width, height: 30)
            }
            
            return CGSize(width: collectionView.width, height: 71)
        }
        
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let item = uiManager.items[section]
        if item.uiCardType == .sleepRange {
            return 12
        }
        
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let item = uiManager.items[section]
        if item.uiCardType == .chart {
            return .zero
        }
        
        return CGSize(width: collectionView.width, height: 46)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = uiManager.items[indexPath.section]
        
        let totalDuration = sleepUIModel?.totalSleepDuration ?? 0
        let deepDuration = sleepUIModel?.deepSleepDuration ?? 0
        let lightDuration = sleepUIModel?.lightSleepDuration ?? 0
        let awakeDuration = sleepUIModel?.awakeDuration ?? 0
        
        if item.uiCardType == .chart {
            let cell = collectionView.dequeueReusableCell(withClass: XWHSleepDayChartCTCell.self, for: indexPath)
            
            cell.update(legendTitles: XWHUIDisplayHandler.getSleepStateStrings(), legendColors: XWHUIDisplayHandler.getSleepStateColors())
            return cell
        }
        
        if item.uiCardType == .curDatas {
            let cell = collectionView.dequeueReusableCell(withClass: XWHSleepScoreCTCell.self, for: indexPath)
            var score = 0
            var sQuality = ""
            var tip = ""
            var bTime = ""
            var eTime = ""
            
            if dateType == .day {
                bTime = sleepUIModel?.bedTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
                eTime = sleepUIModel?.riseTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
                
                var scoreArray = [Int]()
                var tipArray = [String]()
                
                // 睡眠总时长得分
                var tmpScore = XWHUIDisplayHandler.getDaySleepTotalDurationScore(totalDuration)
                scoreArray.append(tmpScore)
                
                // 睡眠总时长提示
                var tmpTip = XWHUIDisplayHandler.getDaySleepTotalDurationTip(totalDuration)
                tipArray.append(tmpTip)
                
                // 入睡时间评分
                tmpScore = XWHUIDisplayHandler.getDayBeginSleepTimeScore(bTime)
                scoreArray.append(tmpScore)

                // 入睡时间提示
                tmpTip = XWHUIDisplayHandler.getDayBeginSleepTimeTip(tmpScore)
                tipArray.append(tmpTip)

                
                // 入睡时长评分
                tmpScore = XWHUIDisplayHandler.getDayBeginSleepDurationScore(0)
                scoreArray.append(tmpScore)

                // 入睡时长提示
                tmpTip = XWHUIDisplayHandler.getDayBeginSleepDurationTip(tmpScore)
                tipArray.append(tmpTip)
                
                // 深睡时长评分
                tmpScore = XWHUIDisplayHandler.getDayDeepSleepDurationScore(deepDuration)
                scoreArray.append(tmpScore)

                // 深睡时长提示
                tmpTip = XWHUIDisplayHandler.getDayDeepSleepDurationTip(tmpScore)
                tipArray.append(tmpTip)
                
                // 夜醒时长评分
                tmpScore = XWHUIDisplayHandler.getDayAwakeInNightScore(0)
                scoreArray.append(tmpScore)

                // 夜醒时长提示
                tmpTip = XWHUIDisplayHandler.getDayAwakeInNightTip(tmpScore)
                tipArray.append(tmpTip)
                
                // 起床稳定性评分
                tmpScore = XWHUIDisplayHandler.getDayWakeupStabilityScore(awakeDuration)
                scoreArray.append(tmpScore)
                
                tipArray.append(R.string.xwhHealthyText.好的睡眠是身体健康最基本的保障())
                
                score = scoreArray.sum()
                tip = tipArray.joined(separator: R.string.xwhHealthyText.分割逗号())
            } else {
                score = XWHUIDisplayHandler.getWeekMonthYearSleepTotalDurationScore(totalDuration)
                tip = XWHUIDisplayHandler.getWeekMonthYearSleepTipString(totalDuration)
            }
    
            sQuality = XWHUIDisplayHandler.getSleepQualityString(score)
            cell.update(score: score, sleepQuality: sQuality, sleepTip: tip, bTime: bTime, eTime: eTime, dateType: dateType)

            return cell
        }
        
        if item.uiCardType == .sleepRange {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMultiColorLinearCTCell.self, for: indexPath)
                cell.update(values: [deepDuration, lightDuration, awakeDuration], colors: XWHUIDisplayHandler.getSleepStateColors())
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHSleepCommonCTCell.self, for: indexPath)
            let titleStr = XWHUIDisplayHandler.getSleepRangeStrings(dateType)[indexPath.item - 1]
            var valueStr = ""
            var tipStr = ""
            
            let sleepRateStrs = XWHUIDisplayHandler.getSleepRateStrings(deepDuration, lightDuration, awakeDuration, totalDuration)
            if indexPath.item == 1 {
                valueStr = XWHUIDisplayHandler.getSleepDurationString(deepDuration)
                tipStr = sleepRateStrs[indexPath.item - 1] + " " + XWHUIDisplayHandler.getDeepSleepRangeString(deepDuration)
            } else if indexPath.item == 2 {
                valueStr = XWHUIDisplayHandler.getSleepDurationString(lightDuration)
                tipStr = sleepRateStrs[indexPath.item - 1] + " " + XWHUIDisplayHandler.getDeepSleepRangeString(lightDuration)
            } else if indexPath.item == 3 {
                valueStr = XWHUIDisplayHandler.getSleepDurationString(awakeDuration)
                tipStr = sleepRateStrs[indexPath.item - 1] + " " + XWHUIDisplayHandler.getDeepSleepRangeString(awakeDuration)
            } else if indexPath.item == 4 {
                let awakeTimes = sleepUIModel?.awakeCount ?? 0
                valueStr = "\(awakeTimes) " + R.string.xwhHealthyText.次()
                tipStr = XWHUIDisplayHandler.getAwakeTimesRangeString(awakeTimes)
            }
            cell.update(titleStr, valueStr, tipStr, XWHUIDisplayHandler.getSleepRangeColors()[0])

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = uiManager.items[indexPath.section]

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: XWHHealthyCTReusableView.self, for: indexPath)
            header.textLb.text = uiManager.getItemTitle(item, dateSegmentType: dateType)
            
            header.button.isHidden = true

            header.clickAction = nil
            
            guard let btnTitle = uiManager.getItemDetailText(item) else {
                return header
            }
            
            header.button.isHidden = false
            header.setDetailButton(title: btnTitle)
            header.clickAction = { [unowned self] in
                self.gotoSleepIntroduction()
            }
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = uiManager.items[indexPath.section]
    }
    
}


// MARK: - DidSelectPopMenuItem
extension XWHHealthySleepCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 1 {
            gotoAllData()
            return
        }
    }
}

// MARK: - Jump UI
extension XWHHealthySleepCTVC {
    
    /// 跳转到所有数据
    private func gotoAllData() {
        let vc = XWHSleepAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到详细说明
    private func gotoSleepIntroduction() {
        let vc = XWHSleepIntroductionTXVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Api
extension XWHHealthySleepCTVC {
    
    private func getSleepExistDate() {
        let cDate = getSelectedDate()
//        XWHProgressHUD.show()
        _getSleepExistDate(cDate, sDateType: dateType) { isExist in
//            if isExist {
//                XWHProgressHUD.hide()
//            }
        }
    }
    
    private func _getSleepExistDate(_ sDate: Date, sDateType: XWHHealthyDateSegmentType, _ completion: ((Bool) -> Void)?) {
        if existDataDateItemsContains(sDate, sDateType: sDateType) {
            completion?(true)
            return
        }
        
        var rDateType = sDateType
        if sDateType == .week {
            rDateType = .day
        }
        XWHHealthyVM().getSleepExistDate(date: sDate, dateType: rDateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHHealthyExistDataDateModel else {
                log.debug("心率 - 获取存在数据日期为空")

                return
            }
            
            updateExistDataDateItem(retModel)
            
            completion?(false)
        }
    }
    
    private func getSleep() {
        XWHProgressHUD.show()
        let cDate = getSelectedDate()
        XWHHealthyVM().getSleep(date: cDate, dateType: dateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHHealthySleepUISleepModel else {
                log.error("睡眠 - 获取数据错误")
                
                self.sleepUIModel = nil
                self.cleanUIItems()
                
                self.collectionView.reloadEmptyDataSet()
                
                return
            }
            
            self.sleepUIModel = retModel
            self.loadUIItems()
        }
    }
    
}
