//
//  XWHWeekCalendarView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/17.
//

import UIKit

class XWHWeekCalendarView: UIView {

    private lazy var collectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.isDirectionalLockEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isHidden = false
        return collectionView
    }()
    
    /// 日历开始的时间
    lazy var startDate = XWHCalendarHelper.startDate
    /// 日历的结束时间
    lazy var endDate = Date()
    
    lazy var sDayDate = Date() {
        didSet {

        }
    }
    lazy var curWeekDates: [Date] = []
    
    var clickDateHandler: ((Date) -> Void)?
    var didScrollToStartDate: ((Date) -> Void)?
    lazy var curBMontDate: Date = Date().monthBegin
    
    lazy var atSums: [XWHActivitySumUIModel] = []
    
    private lazy var dateList: [[Date]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        addSubview(collectionView)
        
        registerViews()
        
        loadDates()
    }
    
    @objc func relayoutSubViews() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func registerViews() {
        collectionView.register(cellWithClass: XWHWeekCalendarWeekDayCell.self)
    }
    
    func reloadData() {
        collectionView.reloadData()
        scrollTo()
    }

}

// MARK: - Handle Dates
extension XWHWeekCalendarView {
    
    private func loadDates() {
        let startDateBegin = startDate.weekBegin
        let endDateBegin = endDate.weekBegin
        var curWeekDateBegin = startDateBegin
        var iWeekDates: [Date] = []
        
        while curWeekDateBegin <= endDateBegin {
            iWeekDates.removeAll()
            for i in 0 ..< 7 {
                let iDate = curWeekDateBegin.adding(.day, value: i)
                iWeekDates.append(iDate)
            }
            
            dateList.append(iWeekDates)
            curWeekDateBegin = iWeekDates[6].adding(.day, value: 1)
        }
        
        collectionView.reloadData()
        scrollTo()
    }
    
    private func scrollTo() {
        var toSection = 0
        let sDayDateBegin = self.sDayDate.dayBegin
        for (i, iDates) in self.dateList.enumerated() {
            if iDates.contains(where: { $0 == sDayDateBegin }) {
                toSection = i
                break
            }
        }
        if !dateList.isEmpty {
            curWeekDates = dateList[toSection]
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else {
                return
            }
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: toSection), at: .left, animated: false)
            self.collectionView.isPagingEnabled = true
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
@objc extension XWHWeekCalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateList[section].count
    }
    
    // - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iWidth = (collectionView.width / 7)
        return CGSize(width: iWidth, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iDate = dateList[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: XWHWeekCalendarWeekDayCell.self, for: indexPath)
        
        cell.updateActivityRings(atSumUIModel: nil)
        

        if iDate.isInToday {
        
        } else if iDate.dayBegin == sDayDate.dayBegin  {

        }

        if let iSum = atSums.first(where: { iDate.dayBegin == ($0.calendarDate.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()).dayBegin }) {
            cell.updateActivityRings(atSumUIModel: iSum)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return UICollectionReusableView()
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let iDate = dateList[indexPath.section][indexPath.item]
        sDayDate = iDate
        clickDateHandler?(iDate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPaths = collectionView.indexPathsForVisibleItems
        if indexPaths.isEmpty {
            return
        }
        let iDate = dateList[indexPaths[0].section][0]
        if iDate == sDayDate {
            return
        }
        
        sDayDate = iDate
        curWeekDates = dateList[indexPaths[0].section]
        didScrollToStartDate?(iDate)
    }
    
}
