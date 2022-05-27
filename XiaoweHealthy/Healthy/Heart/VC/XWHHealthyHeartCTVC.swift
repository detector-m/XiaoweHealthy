//
//  XWHHealthyHeartCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit


/// 运动健康 - 心率
class XWHHealthyHeartCTVC: XWHHealthyBaseCTVC {
    
    override var popMenuItems: [String] {
        [R.string.xwhHealthyText.心率设置(), R.string.xwhHealthyText.所有数据()]
    }
    
    override var isHasLastCurDataItem: Bool {
        return isLast(lastItem)
    }
    
    var heartUIModel: XWHHeartUIHeartModel?
    private lazy var lastItem = XWHHealthyDataManager.getCurrentHeart()
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = R.string.xwhHealthyText.心率()
        titleBtn.titleForNormal = R.string.xwhHealthyText.心率()
        
        cleanUIItems()
        
        getDataExistDate()
        getData()
    }
    
    override func registerViews() {
        super.registerViews()
        
        collectionView.register(cellWithClass: XWHHeartCommonCTCell.self)
        collectionView.register(cellWithClass: XWHHeartGradientCTCell.self)
        collectionView.register(cellWithClass: XWHHeartRangeCTCell.self)
        
        collectionView.register(cellWithClass: XWHHeartChartCTCell.self)
    }
    
    override func clickDateBtn() {
        showCalendar() { [unowned self] scrollDate, cDateType in
            self.getDataExistDate(scrollDate, cDateType) { isExist in
            }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
        getDataExistDate()
        getData()
    }
    
    func loadUIItems() {
        uiManager.loadItems(.heart)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.loadItems(.heart)
        uiManager.cleanItems(without: [.chart])
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyHeartCTVC {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .chart {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHeartChartCTCell.self, for: indexPath)
            
            let cSDate = getSelectedDate()
            let dateText = getSelectedDateRangeString() + " " + R.string.xwhHealthyText.平均心率()
            
            cell.update(dateText: dateText, sDate: cSDate, dateType: dateType, uiModel: heartUIModel)
            
            return cell
        }
        
        if item.uiCardType == .curDatas {
            if indexPath.item == 0, isHasLastCurDataItem {
                let cell = collectionView.dequeueReusableCell(withClass: XWHHeartGradientCTCell.self, for: indexPath)
                
                cell.update(uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item], lastItem?.value.string ?? "0", lastItem?.formatDate()?.localizedString(withFormat: XWHDate.monthDayHourMinute) ?? "")
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHHeartCommonCTCell.self, for: indexPath)
            
            let titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
            var valueStr = ""
            if titleStr == R.string.xwhHealthyText.心率范围() {
                valueStr = heartUIModel?.rateRange ?? "0"
            } else if titleStr == R.string.xwhHealthyText.静息心率() {
                valueStr = heartUIModel?.restRate.string ?? ""
            } else if titleStr == R.string.xwhHealthyText.平均心率() {
                valueStr = heartUIModel?.avgRate.string ?? ""
            }
        
            cell.update(titleStr, valueStr)

            return cell
        }
        
        if item.uiCardType == .heartRange {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHeartRangeCTCell.self, for: indexPath)
            
            cell.update(indexPath.item, heartUIModel?.rateSection ?? XWHHeartUIHeartSectionModel())

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = uiManager.items[indexPath.section]
    }
    
    override func didSelectSupplementaryView(at indexPath: IndexPath) {
        gotoHeartIntroduction()
    }
    
}

// MARK: - DidSelectPopMenuItem
extension XWHHealthyHeartCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 0 {
            XWHDevice.gotoDevSetHeart(at: self)
        } else if index == 1 {
            gotoAllData()
        }
    }
    
}

// MARK: - Jump UI
extension XWHHealthyHeartCTVC {
    
    /// 跳转到所有数据
    private func gotoAllData() {
        let vc = XWHHeartAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到详细说明
    private func gotoHeartIntroduction() {
        let vc = XWHHeartIntroductionTXVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Api
extension XWHHealthyHeartCTVC {
    
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
        XWHHealthyVM().getHeartExistDate(date: sDate, dateType: rDateType) { [unowned self] error in
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
    
    private func getData() {
        XWHProgressHUD.show()
        let cDate = getSelectedDate()
        XWHHealthyVM().getHeart(date: cDate, dateType: dateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.heartUIModel = nil
            self.loadUIItems()
            self.cleanUIItems()
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHHeartUIHeartModel else {
                log.debug("心率 - 获取数据为空")

                self.heartUIModel = nil
                self.cleanUIItems()
                
//                self.collectionView.reloadEmptyDataSet()
                
                return
            }
            
            self.heartUIModel = retModel
            self.loadUIItems()
        }
    }
    
}
