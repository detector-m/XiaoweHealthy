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
            curBeginDate = sDate.beginning(of: .year) ?? Date()
        }
    }
    
    /// 选择日期 月的开始时间
    override var sBeginDate: Date {
        sDate.beginning(of: .month) ?? sDate
    }
    
    lazy var preNextView = XWHCalendarPreNextBtnView(dateType: .month)

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
        let mbDate = getMonthBeginDate(iMonth)

        cell.textLb.text = iMonth.string + R.string.xwhHealthyText.月()
        
        let now = Date()
        let nowBeginDate = now.beginning(of: .month) ?? now

        if nowBeginDate >= mbDate { // 过去或当前的月份
            if nowBeginDate == mbDate {
                cell.curIndicator.isHidden = false
                cell.textLb.textColor = btnBgColor
            } else {
                cell.curIndicator.isHidden = true
                cell.textLb.textColor = fontDarkColor
            }
            cell.dotIndicator.isHidden = false
        } else { // 未来的月份
            cell.curIndicator.isHidden = true
            cell.textLb.textColor = fontDarkColor.withAlphaComponent(0.17)
            cell.dotIndicator.isHidden = true
        }
        
        if sBeginDate == mbDate {
            cell.selectedIndicator.isHidden = false
        } else {
            cell.selectedIndicator.isHidden = true
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let iMonth = items[indexPath.item]
        let mbDate = getMonthBeginDate(iMonth)
        
        let now = Date()
        if now >= mbDate { // 过去或当前的月份
            if sBeginDate == mbDate {
                return
            }
            
            sDate = mbDate
            selectHandler?(sDate)
        } else { // 未来的月份
            return
        }
    }
    
}

extension XWHCalendarMonthView {
    
    private func getMonthBeginDate(_ month: Int) -> Date {
        var tDate = curBeginDate
        tDate.month = month
        
        let retDate = tDate.beginning(of: .month) ?? tDate
        
        return retDate
    }
    
}

