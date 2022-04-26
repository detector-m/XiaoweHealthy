//
//  XWHCalendarMonthView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarMonthView: XWHCalendarYearView {

    override var sDate: Date {
        didSet {
            beginDate = sDate.beginning(of: .month) ?? Date()
        }
    }
    lazy var preNextView = XWHCalendarPreNextBtnView()

    override func addSubViews() {
        super.addSubViews()
        
        addSubview(preNextView)
        
        items = stride(from: 1, through: 12, by: 1).map({ $0 })
        collectionView.reloadData()
    }
    
    override func relayoutSubViews() {
        preNextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(25)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(preNextView.snp.bottom).offset(29)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHCalendarMonthCTCell.self)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHCalendarMonthView {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cWidth = collectionView.width.int - 3 * 2
        let iWidth = cWidth  / 4
        return CGSize(width: iWidth, height: iWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: XWHCalendarMonthCTCell.self, for: indexPath)
        
        let iMonth = items[indexPath.item]
        cell.textLb.text = iMonth.string + R.string.xwhHealthyText.月()
        
        let now = Date()
//        if iYear <= cDate.year {
//            if iYear == cDate.year {
//                cell.curIndicator.isHidden = false
//                cell.textLb.textColor = btnBgColor
//            } else {
//                cell.curIndicator.isHidden = true
//                cell.textLb.textColor = fontDarkColor
//            }
//            cell.dotIndicator.isHidden = false
//        } else {
//            cell.curIndicator.isHidden = true
//            cell.textLb.textColor = fontDarkColor.withAlphaComponent(0.17)
//            cell.dotIndicator.isHidden = true
//        }
//
//        if sDate.year == iYear {
//            cell.selectedIndicator.isHidden = false
//        } else {
//            cell.selectedIndicator.isHidden = true
//        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let iYear = items[indexPath.item]
//        let cDate = Date()
//        if iYear <= cDate.year {
//            if sDate.year == iYear {
//                return
//            }
//
//        } else {
//            return
//        }
    }
    
}

