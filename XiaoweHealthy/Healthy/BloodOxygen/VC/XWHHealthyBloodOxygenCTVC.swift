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
        guard let lModel = lastBoModel, let lDate = lModel.formatDate() else {
            return false
        }
        
        switch dateType {
        case .day:
            return lDate.isInToday
            
        case .week:
            let nowWeekBegin = Date().weekBegin
            return nowWeekBegin == lDate.weekBegin
            
        case .month:
            return lDate.isInCurrentMonth
            
        case .year:
            return lDate.isInCurrentYear
        }
    }
    
    private var boUIModel: XWHBOUIBloodOxygenModel?
    private lazy var lastBoModel = XWHHealthyDataManager.getCurrentBloodOxygen()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = R.string.xwhHealthyText.血氧饱和度()
        
        getBloodOxygenExistDate()
        getBloodOxygen()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHBOCommonCTCell.self)
        collectionView.register(cellWithClass: XWHBOGradientCTCell.self)
        collectionView.register(cellWithClass: XWHBOTipCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHHealthyCTReusableView.self)
    }
    
    override func clickDateBtn() {
        showCalendar() { [unowned self] scrollDate, cDateType in
            self._getBloodOxygenExistDate(scrollDate, sDateType: cDateType) { isExist in
            }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
        getBloodOxygenExistDate()
        getBloodOxygen()
    }
    
    func loadUIItems() {
        uiManager.loadItems(.bloodOxygen)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
        uiManager.cleanItems(without: [.chart])
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyBloodOxygenCTVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return uiManager.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = uiManager.items[section]
        if item.uiCardType == .curDatas {
            return uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem).count
        }
        
        if item.uiCardType == .boTip {
            return 1
        }
        
        return 0
    }
    
    // - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = uiManager.items[indexPath.section]
        if item.uiCardType == .curDatas {
            return CGSize(width: collectionView.width, height: 71)
        }
        
        if item.uiCardType == .boTip {
            return CGSize(width: collectionView.width, height: 170)
        }
        
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let item = uiManager.items[section]
        if item.uiCardType == .curDatas {
            return 12
        }
        
        if item.uiCardType == .heartRange {
            return 12
        }
        
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 46)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .curDatas {
            if indexPath.item == 0, isHasLastCurDataItem {
                let cell = collectionView.dequeueReusableCell(withClass: XWHBOGradientCTCell.self, for: indexPath)
                
                cell.update(uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item], lastBoModel?.value.string ?? "0", lastBoModel?.formatDate()?.localizedString(withFormat: XWHDate.monthDayHourMinute) ?? "")
                
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
                self.gotoBOIntroduction()
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
extension XWHHealthyBloodOxygenCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 1 {
            gotoAllData()
            return
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
    
    private func getBloodOxygenExistDate() {
        let cDate = getSelectedDate()
//        XWHProgressHUD.show()
        _getBloodOxygenExistDate(cDate, sDateType: dateType) { isExist in
//            if isExist {
//                XWHProgressHUD.hide()
//            }
        }
    }
    
    private func _getBloodOxygenExistDate(_ sDate: Date, sDateType: XWHHealthyDateSegmentType, _ completion: ((Bool) -> Void)?) {
        if existDataDateItemsContains(sDate, sDateType: sDateType) {
            completion?(true)
            return
        }
        
        var rDateType = sDateType
        if sDateType == .week {
            rDateType = .day
        }
        XWHHealthyVM().getBloodOxygenExistDate(date: sDate, dateType: rDateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHHealthyExistDataDateModel else {
                log.debug("血氧 - 获取存在数据日期为空")
                return
            }
            
            updateExistDataDateItem(retModel)
            
            completion?(false)
        }
    }
    
    private func getBloodOxygen() {
        XWHProgressHUD.show()
        let cDate = getSelectedDate()
        XWHHealthyVM().getBloodOxygen(date: cDate, dateType: dateType) { [unowned self] error in
            XWHProgressHUD.hide()
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHBOUIBloodOxygenModel else {
                log.debug("血氧 - 获取数据为空")
                self.boUIModel = nil
                self.cleanUIItems()
                
                self.collectionView.reloadEmptyDataSet()
                
                return
            }
            
            self.boUIModel = retModel
            self.loadUIItems()
        }
    }
    
}

