//
//  XWHHealthyMoodCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit


// FIXME: 需要完善
class XWHHealthyMoodCTVC: XWHHealthyBaseCTVC {
    
    override var popMenuItems: [String] {
        [R.string.xwhDeviceText.情绪压力设置(), R.string.xwhHealthyText.所有数据()]
    }
    
    override var isHasLastCurDataItem: Bool {
        return isLast(lastItem)
    }
    
    var uiModel: XWHMoodUIMoodModel?
    private lazy var lastItem = XWHHealthyDataManager.getCurrentMentalState()

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = R.string.xwhHealthyText.情绪()
        titleBtn.titleForNormal = R.string.xwhHealthyText.情绪()
        
//        loadUIItems()
        cleanUIItems()
        
        getDataExistDate()
        getData()
    }
    
    override func registerViews() {
        super.registerViews()
        
        collectionView.register(cellWithClass: XWHMoodChartCTCell.self)
        collectionView.register(cellWithClass: XWHMoodRangeCTCell.self)
        collectionView.register(cellWithClass: XWHMoodGradientCTCell.self)
        
        collectionView.register(cellWithClass: XWHMultiColorLinearCTCell.self)
    }
    
    override func clickDateBtn() {
        showCalendar() { [unowned self] scrollDate, cDateType in
            self.getDataExistDate(scrollDate, cDateType) { isExist in }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
        
        getDataExistDate()
        getData()
    }
    
    func loadUIItems() {
        uiManager.loadItems(.mood, isHasCurDatasItem: isHasLastCurDataItem)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.loadItems(.mood, isHasCurDatasItem: false)
        uiManager.cleanItems(without: [.chart])
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyMoodCTVC {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .chart {
            let cell = collectionView.dequeueReusableCell(withClass: XWHMoodChartCTCell.self, for: indexPath)
            
            let cSDate = getSelectedDate()
            let dateText = R.string.xwhHealthyText.平均情绪状态()
            cell.update(dateText: dateText, sDate: cSDate, dateType: dateType, uiModel: uiModel)
            
            return cell
        }
        
        if item.uiCardType == .curDatas {
            var titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
            var valueStr = ""
            var unit = ""
            
            if indexPath.item == 0, isHasLastCurDataItem {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMoodGradientCTCell.self, for: indexPath)
                
                titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
                
                let value = lastItem?.mood ?? 0
                valueStr = XWHUIDisplayHandler.getMoodString(value)
                unit = ""
                let tipText = lastItem?.formatDate()?.localizedString(withFormat: XWHDate.monthDayHourMinute) ?? ""
                cell.update(titleStr, valueStr, unit, tipText)
                
                return cell
            }
        }
        
        if item.uiCardType == .moodRange {
            var values: [Double] = [0, 0, 0]
            if let cModel = uiModel {
                values = XWHUIDisplayHandler.getMoodRangeRates(cModel)
            }
            
            // 分布图例
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMultiColorLinearCTCell.self, for: indexPath)
                
                cell.update(values: values.map({ $0.int }), colors: XWHUIDisplayHandler.getMoodRangeColors())
                
                return cell
            }
            
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHMoodRangeCTCell.self, for: indexPath)
            let rate = values[indexPath.row - 1]
            cell.update(indexPath.row - 1, rate.int)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = uiManager.items[indexPath.section]
    }
    
    override func didSelectSupplementaryView(at indexPath: IndexPath) {
        gotoMoodIntroduction()
    }
    
}

// MARK: - DidSelectPopMenuItem
extension XWHHealthyMoodCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 0 {
            XWHDevice.gotoDevSetMentalStress(at: self)
        } else if index == 1 {
            gotoAllData()
        }
    }
    
}

// MARK: - Jump UI
extension XWHHealthyMoodCTVC {
    
    /// 跳转到所有数据
    private func gotoAllData() {
        let vc = XWHMoodAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到详细说明
    private func gotoMoodIntroduction() {
        let vc = XWHMoodIntroductionTXVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Api
extension XWHHealthyMoodCTVC {
    
    private func getDataExistDate() {
        let cDate = getSelectedDate()
//        XWHProgressHUD.show()
        getDataExistDate(cDate, dateType) { isExist in
//            if isExist {
//                XWHProgressHUD.hide()
//            }
        }
    }
    
    private func getDataExistDate(_ sDate: Date, _ sDateType: XWHHealthyDateSegmentType, _ completion: ((Bool) -> Void)?) {
        if existDataDateItemsContains(sDate, sDateType: sDateType) {
            completion?(true)
            return
        }
        
        var rDateType = sDateType
        if sDateType == .week {
            rDateType = .day
        }
        XWHHealthyVM().getMoodExistDate(date: sDate, dateType: rDateType) { [weak self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            guard let self = self else {
                return
            }
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHHealthyExistDataDateModel else {
                log.debug("情绪 - 获取存在数据日期为空")
                return
            }
            
            self.updateExistDataDateItem(retModel)
            
            completion?(false)
        }
    }
    
    private func getData() {
        XWHProgressHUD.show()
        let cDate = getSelectedDate()
        XWHHealthyVM().getMood(date: cDate, dateType: dateType) { [weak self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            guard let self = self else {
                return
            }
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.uiModel = nil
//            self.loadUIItems()
            self.cleanUIItems()
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHMoodUIMoodModel else {
                log.debug("情绪 - 获取数据为空")
                self.uiModel = nil
                self.cleanUIItems()
                
//                self.collectionView.reloadEmptyDataSet()
                
                return
            }
            
            self.uiModel = retModel
            self.loadUIItems()
        }
    }
    
}
