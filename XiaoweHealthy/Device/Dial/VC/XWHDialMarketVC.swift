//
//  XWHDialMarketVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHDialMarketVC: XWHDialContentBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHDialTitleCTCell.self)
        collectionView.register(cellWithClass: XWHDialCTCell.self)
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.width - 32, height: 48)
        }
        let cWidth = (collectionView.width - 32 - 4) / 3
        return CGSize(width: cWidth.int, height: 154)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withClass:XWHDialTitleCTCell.self, for: indexPath)
            
            cell.textLb.text = "最新上传 \(indexPath.item)"
            
            cell.clickAction = { [unowned self] in
                self.gotoMore()
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withClass: XWHDialCTCell.self, for: indexPath)
        
        cell.imageView.image = R.image.devicePlaceholder()
        cell.textLb.text = "index \(indexPath.item)"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            return
        }
        gotoDialDetail()
    }
    
}


// MARK: - Jump
extension XWHDialMarketVC {
    
    private func gotoDialDetail() {
        let vc = XWHDialDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gotoMore() {
        let vc = XWHDialMoreVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
