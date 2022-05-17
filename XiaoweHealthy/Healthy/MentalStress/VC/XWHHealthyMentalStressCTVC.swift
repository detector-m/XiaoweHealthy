//
//  XWHHealthyMentalStressCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHHealthyMentalStressCTVC: XWHHealthyBaseCTVC {
    
    override var popMenuItems: [String] {
        [R.string.xwhDeviceText.压力设置(), R.string.xwhHealthyText.所有数据()]
    }
    
    override var isHasLastCurDataItem: Bool {
        return isLast(lastItem)
    }
    
    var msUIModel: XWHMentalStressUIStressModel?
    private lazy var lastItem = XWHHealthyDataManager.getCurrentMentalState()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = R.string.xwhHealthyText.压力()
        
        getMentalStressExistDate()
        getMentalStress()
    }
    
    override func registerViews() {
        super.registerViews()
        
        collectionView.register(cellWithClass: XWHMentalStressCommonCTCell.self)
        collectionView.register(cellWithClass: XWHMentalStressGradiendtCTCell.self)
        
        collectionView.register(cellWithClass: XWHMultiColorLinearCTCell.self)

        collectionView.register(cellWithClass: XWHMentalStressRangeCTCell.self)
        
        collectionView.register(cellWithClass: XWHMentalStressChartCTCell.self)
    }
    
    override func clickDateBtn() {
        showCalendar() { [unowned self] scrollDate, cDateType in
            self._getMentalStressExistDate(scrollDate, sDateType: cDateType) { isExist in
            }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
        getMentalStressExistDate()
        getMentalStress()
    }
    
    func loadUIItems() {
        uiManager.loadItems(.mentalStress)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.cleanItems(without: [.chart])
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyMentalStressCTVC {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .chart {
            let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressChartCTCell.self, for: indexPath)
            
            let cSDate = getSelectedDate()
            let dateText = getSelectedDateRangeString() + " " + R.string.xwhHealthyText.平均压力值()
            
            cell.update(dateText: dateText, sDate: cSDate, dateType: dateType, uiModel: msUIModel)
            
            return cell
        }
        
        if item.uiCardType == .curDatas {
            var titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
            var valueStr = ""
            var unit = ""
            
            if indexPath.item == 0, isHasLastCurDataItem {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressGradiendtCTCell.self, for: indexPath)
                
                titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
                
                let value = lastItem?.stress ?? 0
                valueStr = value.string
                unit = XWHUIDisplayHandler.getMentalStressRangeString(value)
                let tipText = lastItem?.formatDate()?.localizedString(withFormat: XWHDate.monthDayHourMinute) ?? ""
                cell.update(titleStr, valueStr, unit, tipText)
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressCommonCTCell.self, for: indexPath)
            
            titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
            valueStr = ""
            unit = ""
            
            if titleStr == R.string.xwhHealthyText.压力范围() {
                valueStr = msUIModel?.range.map({ $0.string }).joined(separator: "-") ?? ""
            } else if titleStr == R.string.xwhHealthyText.平均压力值() {
                let value = msUIModel?.averageVal ?? 0
                valueStr = value.string
                unit = XWHUIDisplayHandler.getMentalStressRangeString(value)
            }
            
            cell.update(titleStr, valueStr, unit)

            return cell
        }
        
        if item.uiCardType == .mentalStressRange {
            /// 放松状态频次
            let relaxNumber = msUIModel?.relaxNumber ?? 0
            /// 正常状态频次
            let normalNumber = msUIModel?.normalNumber ?? 0
            /// 中等状态频次
            let mediumNumber = msUIModel?.mediumNumber ?? 0
            /// 高等状态频次
            let highNumber = msUIModel?.highNumber ?? 0
            /// 所有状态频次
            var totalNumber = msUIModel?.totalNumber ?? 0
            
            if totalNumber <= 0 {
                totalNumber = 100
            }
            
            let values = [relaxNumber, normalNumber, mediumNumber, highNumber]
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMultiColorLinearCTCell.self, for: indexPath)
                
                cell.update(values: values, colors: XWHUIDisplayHandler.getMentalStressRangeColors())
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressRangeCTCell.self, for: indexPath)
            
            let cIndex = indexPath.item - 1
            let rate = (values[cIndex].cgFloat / totalNumber.cgFloat) * 100
            cell.update(cIndex, rate.int)

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = uiManager.items[indexPath.section]
    }
    
    override func didSelectSupplementaryView(at indexPath: IndexPath) {
        gotoMentalStressIntroduction()
    }
    
}


// MARK: - DidSelectPopMenuItem
extension XWHHealthyMentalStressCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 0 {
            XWHDevice.gotoDevSetMentalStress(at: self)
        } else if index == 1 {
            gotoAllData()
        }
    }
    
}

// MARK: - Jump UI
extension XWHHealthyMentalStressCTVC {
    
    /// 跳转到所有数据
    private func gotoAllData() {
        let vc = XWHMentalStressAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到详细说明
    private func gotoMentalStressIntroduction() {
        let vc = XWHMentalStressIntroductionTXVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Api
extension XWHHealthyMentalStressCTVC {
    
    private func getMentalStressExistDate() {
        let cDate = getSelectedDate()
//        XWHProgressHUD.show()
        _getMentalStressExistDate(cDate, sDateType: dateType) { isExist in
//            if isExist {
//                XWHProgressHUD.hide()
//            }
        }
    }
    
    private func _getMentalStressExistDate(_ sDate: Date, sDateType: XWHHealthyDateSegmentType, _ completion: ((Bool) -> Void)?) {
        if existDataDateItemsContains(sDate, sDateType: sDateType) {
            completion?(true)
            return
        }
        
        var rDateType = sDateType
        if sDateType == .week {
            rDateType = .day
        }
        XWHHealthyVM().getMentalStressExistDate(date: sDate, dateType: rDateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHHealthyExistDataDateModel else {
                log.debug("精神压力 - 获取存在数据日期为空")
                return
            }
            
            updateExistDataDateItem(retModel)
            
            completion?(false)
        }
    }
    
    private func getMentalStress() {
        XWHProgressHUD.show()
        let cDate = getSelectedDate()
        XWHHealthyVM().getMentalStress(date: cDate, dateType: dateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHMentalStressUIStressModel else {
                log.debug("精神压力 - 获取数据为空")
                self.msUIModel = nil
                self.loadUIItems()
                self.cleanUIItems()
                
//                self.collectionView.reloadEmptyDataSet()
                
                return
            }
            
            self.msUIModel = retModel
            self.loadUIItems()
        }
    }
    
}
