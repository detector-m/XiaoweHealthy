//
//  XWHCalendarYearView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarYearView: UIView {

    lazy var flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    lazy var items: [Int] = stride(from: 2019, through: 2027, by: 1).map({ $0 })
    
    /// 选择的日期
    lazy var sDate = Date() {
        didSet {
            beginDate = sDate.beginning(of: .year) ?? Date()
        }
    }
    
    /// 当前日期
    lazy var beginDate = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
        registerViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = bgColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
                
        addSubview(collectionView)
    }
    
    @objc func relayoutSubViews() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func registerViews() {
        collectionView.register(cellWithClass: XWHCalendarYearCTCell.self)
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
@objc extension XWHCalendarYearView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cWidth = collectionView.width.int - 4
        let iWidth = cWidth  / 3
        return CGSize(width: iWidth, height: iWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: XWHCalendarYearCTCell.self, for: indexPath)
        
        let iYear = items[indexPath.item]
        cell.textLb.text = iYear.string
        
        let now = Date()
        if iYear <= now.year {
            if iYear == now.year {
                cell.curIndicator.isHidden = false
                cell.textLb.textColor = btnBgColor
            } else {
                cell.curIndicator.isHidden = true
                cell.textLb.textColor = fontDarkColor
            }
            cell.dotIndicator.isHidden = false
        } else {
            cell.curIndicator.isHidden = true
            cell.textLb.textColor = fontDarkColor.withAlphaComponent(0.17)
            cell.dotIndicator.isHidden = true
        }
        
        if sDate.year == iYear {
            cell.selectedIndicator.isHidden = false
        } else {
            cell.selectedIndicator.isHidden = true
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
        let iYear = items[indexPath.item]
        let cDate = Date()
        if iYear <= cDate.year {
            if sDate.year == iYear {
                return
            }
            
        } else {
            return
        }
    }
    
}
