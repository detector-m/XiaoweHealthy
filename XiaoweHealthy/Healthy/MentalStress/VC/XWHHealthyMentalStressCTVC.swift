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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = R.string.xwhHealthyText.压力()
        
        loadUIItems()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHMentalStressCommonCTCell.self)
        collectionView.register(cellWithClass: XWHMentalStressGradiendtCTCell.self)
        
        collectionView.register(cellWithClass: XWHMultiColorLinearCTCell.self)

        collectionView.register(cellWithClass: XWHMentalStressRangeCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHHealthyCTReusableView.self)
    }
    
    override func clickDateBtn() {
        showCalendar() { [unowned self] scrollDate, cDateType in
//            self._getBloodOxygenExistDate(scrollDate, sDateType: cDateType) { isExist in
//            }
        }
    }
    
    override func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(false)
//        getBloodOxygenExistDate()
//        getBloodOxygen()
        
        collectionView.reloadData()
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return uiManager.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = uiManager.items[section]
        if item.uiCardType == .curDatas {
            return uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem).count
        }
        
        if item.uiCardType == .mentalStressRange {
            return 5
        }
        
        return 0
    }
    
    // - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = uiManager.items[indexPath.section]
        if item.uiCardType == .curDatas {
            return CGSize(width: collectionView.width, height: 71)
        }
        
        if item.uiCardType == .mentalStressRange {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.width, height: 30)
            }
            
            let cWidth = (collectionView.width - 12) / 2
            return CGSize(width: cWidth.int, height: 71)
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
        
        if item.uiCardType == .mentalStressRange {
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
                let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressGradiendtCTCell.self, for: indexPath)
                
                let titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
//                let valueStr = (lastBoModel?.value.string ?? "0") + "%"
                let valueStr = "50"
                let unit = XWHUIDisplayHandler.getMentalStressRangeString(50)
                let tipText = Date().localizedString(withFormat: XWHDate.monthDayHourMinute)
                cell.update(titleStr, valueStr, unit, tipText)
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressCommonCTCell.self, for: indexPath)
            
            let titleStr = uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item]
            var valueStr = ""
            var unit = ""
            if titleStr == R.string.xwhHealthyText.压力范围() {
                valueStr = "50-100"
            } else if titleStr == R.string.xwhHealthyText.平均压力值() {
                valueStr = 50.string
                unit = XWHUIDisplayHandler.getMentalStressRangeString(50)
            }
            
            cell.update(titleStr, valueStr, unit)

            return cell
        }
        
        if item.uiCardType == .mentalStressRange {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: XWHMultiColorLinearCTCell.self, for: indexPath)
                cell.update(values: [20, 50, 10, 20], colors: XWHUIDisplayHandler.getMentalStressRangeColors())
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHMentalStressRangeCTCell.self, for: indexPath)
            
            cell.update(indexPath.item - 1, 10)

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
                self.gotoMentalStressIntroduction()
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
extension XWHHealthyMentalStressCTVC {
    
    override func didSelectPopMenuItem(at index: Int) {
        if index == 1 {
            gotoAllData()
            return
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
