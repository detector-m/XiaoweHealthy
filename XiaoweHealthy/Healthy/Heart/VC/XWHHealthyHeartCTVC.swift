//
//  XWHHealthyHeartCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit


/// 运动健康 - 心率
class XWHHealthyHeartCTVC: XWHHealthyBaseCTVC {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.xwhHealthyText.心率()
        
        loadUIItems()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHHeartCommonCTCell.self)
        collectionView.register(cellWithClass: XWHHeartGradientCTCell.self)
        collectionView.register(cellWithClass: XWHHeartRangeCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHHealthyCTReusableView.self)
    }
    
    func loadUIItems() {
        uiManager.loadItems(.heart)
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyHeartCTVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return uiManager.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = uiManager.items[section]
        if item.uiCardType == .curDatas {
            return uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem).count
        }
        
        if item.uiCardType == .heartRange {
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
        
        if item.uiCardType == .heartRange {
            let iWidth = ((collectionView.width - 12) / 2).int
            return CGSize(width: iWidth, height: 71)
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
                let cell = collectionView.dequeueReusableCell(withClass: XWHHeartGradientCTCell.self, for: indexPath)
                
                cell.update(uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item], "123", Date().dateString(ofStyle: .short))
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withClass: XWHHeartCommonCTCell.self, for: indexPath)
            
            cell.update(uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem)[indexPath.item], "123")

            return cell
        }
        
        if item.uiCardType == .heartRange {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHeartRangeCTCell.self, for: indexPath)
            
            cell.update(indexPath.item, "")

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = uiManager.items[indexPath.section]

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: XWHHealthyCTReusableView.self, for: indexPath)
            header.textLb.text = uiManager.getItemTitle(item, dateSegmentType: dateType)
            
            header.clickAction = nil
            
            guard let btnTitle = uiManager.getItemDetailText(item) else {
                return header
            }
            
            header.setDetailButton(title: btnTitle)
            header.clickAction = {
                
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
