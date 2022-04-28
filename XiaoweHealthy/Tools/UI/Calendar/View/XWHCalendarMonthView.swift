//
//  XWHCalendarMonthView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarMonthView: XWHCalendarYearView {

    private lazy var _sDate: Date = Date()
    override var sDate: Date {
        get {
            _sDate
        }
        set {
            _sDate = newValue
            curBeginDate = newValue.beginning(of: .year) ?? Date()
        }
    }
    
    /// 选择日期 月的开始时间
    override var sBeginDate: Date {
        sDate.monthBegin
    }
    
    override var curBeginDate: Date {
        get {
            super.curBeginDate
        }
        set {
            super.curBeginDate = newValue.monthBegin
        }
    }
    
    lazy var preNextView = XWHCalendarPreNextBtnView(dateType: .month)

    override func addSubViews() {
        super.addSubViews()
        
        addSubview(preNextView)
        
        items = stride(from: 1, through: 12, by: 1).map({ $0 })
        collectionView.reloadData()
        
        configEventAction()
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


// MARK: - ConfigEventAction
extension XWHCalendarMonthView {
    
    @objc private func configEventAction() {
        preNextView.selectHandler = { [unowned self] cbDate, aType in
            self.curBeginDate = cbDate
            self.scrollDateHandler?(cbDate)
            self.collectionView.reloadData()
        }
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
        let nowBeginDate = now.monthBegin

        cell.dotIndicator.isHidden = true

        if nowBeginDate >= mbDate { // 过去或当前的月份
            if nowBeginDate == mbDate {
                cell.nowIndicator.isHidden = false
                cell.textLb.textColor = btnBgColor
            } else {
                cell.nowIndicator.isHidden = true
                cell.textLb.textColor = fontDarkColor
            }
            
            outLabel: for iItem in existDataDateItems {
                for jItem in iItem.items {
                    if jItem.monthBegin == mbDate {
                        cell.dotIndicator.isHidden = false
                        break outLabel
                    }
                }
            }
        } else { // 未来的月份
            cell.nowIndicator.isHidden = true
            cell.textLb.textColor = fontDarkColor.withAlphaComponent(0.17)
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
            collectionView.reloadData()
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
        
        return tDate.monthBegin
    }
    
}

