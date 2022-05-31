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
    
    private lazy var lastItem = XWHHealthyDataManager.getCurrentMentalState()

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = R.string.xwhHealthyText.情绪()
        titleBtn.titleForNormal = R.string.xwhHealthyText.情绪()
        
        loadUIItems()
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
//            self._getMentalStressExistDate(scrollDate, sDateType: cDateType) { isExist in
//            }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
        
//        getMentalStressExistDate()
//        getMentalStress()
        
        collectionView.reloadData()
    }
    
    func loadUIItems() {
        uiManager.loadItems(.mood, isHasCurDatasItem: isHasLastCurDataItem)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.loadItems(.mood)
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
            
//            let cSDate = getSelectedDate()
//            let dateText = getSelectedDateRangeString() + " " + R.string.xwhHealthyText.平均压力值()
//
//            cell.update(dateText: dateText, sDate: cSDate, dateType: dateType, uiModel: msUIModel)
            
            cell.update()
            
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
            /// 积极
            let positiveNumber = 30
            /// 正常
            let normalNumber = 50
            /// 消极
            let negativeNumber = 20
            
            /// 所有状态
//            var totalNumber = positiveNumber + normalNumber + negativeNumber
            
//            if totalNumber <= 0 {
//                totalNumber = 100
//            }
            
            let values = [positiveNumber, normalNumber, negativeNumber]
            // 分布图例
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMultiColorLinearCTCell.self, for: indexPath)
                
                cell.update(values: values, colors: XWHUIDisplayHandler.getMoodRangeColors())
                
                return cell
            }
            
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHMoodRangeCTCell.self, for: indexPath)
            cell.update(indexPath.row - 1, Int(arc4random()) % 120, values[indexPath.row - 1])
            
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
