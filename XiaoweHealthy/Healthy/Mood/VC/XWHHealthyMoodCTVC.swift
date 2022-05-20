//
//  XWHHealthyMoodCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit

class XWHHealthyMoodCTVC: XWHHealthyBaseCTVC {
    
    override var popMenuItems: [String] {
        [R.string.xwhDeviceText.压力设置(), R.string.xwhHealthyText.所有数据()]
    }
    
    override var isHasLastCurDataItem: Bool {
        return false
    }
    
    private lazy var lastItem = XWHHealthyDataManager.getCurrentMentalState()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUIItems()
    }
    
    override func registerViews() {
        super.registerViews()
        
        collectionView.register(cellWithClass: XWHMoodChartCTCell.self)

//        collectionView.register(cellWithClass: XWHMentalStressCommonCTCell.self)
//        collectionView.register(cellWithClass: XWHMentalStressGradiendtCTCell.self)
//        collectionView.register(cellWithClass: XWHMentalStressRangeCTCell.self)
        
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
    }
    
    func loadUIItems() {
        uiManager.loadItems(.mood)
        collectionView.reloadData()
    }
    
    func cleanUIItems() {
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
//            XWHDevice.gotoDevSetMentalStress(at: self)
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
