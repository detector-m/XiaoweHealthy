//
//  XWHHealthyBloodOxygenCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit

/// 运动健康血氧
class XWHHealthyBloodOxygenCTVC: XWHHealthyBaseCTVC {
    
    override var popMenuItems: [String] {
        [R.string.xwhHealthyText.血氧饱和度(), R.string.xwhHealthyText.所有数据()]
    }
    
    override var isHasLastCurDataItem: Bool {
        return isLast(lastItem)
    }
    
    private var boUIModel: XWHBOUIBloodOxygenModel?
    private lazy var lastItem = XWHHealthyDataManager.getCurrentBloodOxygen()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = R.string.xwhHealthyText.血氧饱和度()
        titleBtn.titleForNormal = R.string.xwhHealthyText.血氧饱和度()
        
        cleanUIItems()
        
        getDataExistDate()
        getData()
    }
    
    override func registerViews() {
        super.registerViews()
        
        collectionView.register(cellWithClass: XWHBOCommonCTCell.self)
        collectionView.register(cellWithClass: XWHBOGradientCTCell.self)
        collectionView.register(cellWithClass: XWHBOTipCTCell.self)
        
        collectionView.register(cellWithClass: XWHBOChartCTCell.self)
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
        uiManager.loadItems(.bloodOxygen)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.loadItems(.bloodOxygen)
        uiManager.cleanItems(without: [.chart])
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyBloodOxygenCTVC {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .chart {
            let cell = collectionView.dequeueReusableCell(withClass: XWHBOChartCTCell.self, for: indexPath)
            
            let cSDate = getSelectedDate()
            let dateText = getSelectedDateRangeString() + " " + R.string.xwhHealthyText.平均血氧()
            
            cell.update(dateText: dateText, sDate: cSDate, dateType: dateType, uiModel: boUIModel)
            
            return cell
        }
        
        if item.uiCardType == .curDatas {
            if indexPath.item == 0, isHasLastCurDataItem {
                let cell = collectionView.dequeueReusableCell(withClass: XWHBOGradientCTCell.self, for: indexPath)
                
                let valueStr = (lastItem?.value.string ?? "0") + "%"
                cell.update(uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item], valueStr, lastItem?.formatDate()?.localizedString(withFormat: XWHDate.monthDayHourMinute) ?? "")
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHBOCommonCTCell.self, for: indexPath)
            
            let titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
            var valueStr = ""
            
            if titleStr == R.string.xwhHealthyText.血氧饱和度范围() {
                valueStr = boUIModel?.bloodOxygenRange ?? ""
            } else if titleStr == R.string.xwhHealthyText.平均血氧饱和度() {
                valueStr = boUIModel?.avgBloodOxygen.string ?? "0"
            }
            
            cell.update(titleStr, valueStr)

            return cell
        }
        
        if item.uiCardType == .boTip {
            let cell = collectionView.dequeueReusableCell(withClass: XWHBOTipCTCell.self, for: indexPath)

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = uiManager.items[indexPath.section]
    }
    
    override func didSelectSupplementaryView(at indexPath: IndexPath) {
        gotoBOIntroduction()
    }
    
}


// MARK: - DidSelectPopMenuItem
extension XWHHealthyBloodOxygenCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 0 {
            XWHDevice.gotoDevSetBloodOxygen(at: self)
        } else if index == 1 {
            gotoAllData()
        }
    }
    
}


// MARK: - Jump UI
extension XWHHealthyBloodOxygenCTVC {
    
    /// 跳转到所有数据
    private func gotoAllData() {
        let vc = XWHBOAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到详细说明
    private func gotoBOIntroduction() {
        let vc = XWHBOIntroductionTXVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Api
extension XWHHealthyBloodOxygenCTVC {
    
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
        XWHHealthyVM().getBloodOxygenExistDate(date: sDate, dateType: rDateType) { [weak self] error in
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
                log.debug("血氧 - 获取存在数据日期为空")
                return
            }
            
            self.updateExistDataDateItem(retModel)
            
            completion?(false)
        }
    }
    
    private func getData() {
        XWHProgressHUD.show()
        let cDate = getSelectedDate()
        XWHHealthyVM().getBloodOxygen(date: cDate, dateType: dateType) { [weak self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            guard let self = self else {
                return
            }
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.boUIModel = nil
//            self.loadUIItems()
            self.cleanUIItems()
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHBOUIBloodOxygenModel else {
                log.debug("血氧 - 获取数据为空")
                self.boUIModel = nil
                self.cleanUIItems()
                
//                self.collectionView.reloadEmptyDataSet()
                
                return
            }
            
            self.boUIModel = retModel
            self.loadUIItems()
        }
    }
    
}

