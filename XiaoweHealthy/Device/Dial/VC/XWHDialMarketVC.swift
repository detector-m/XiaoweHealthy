//
//  XWHDialMarketVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHDialMarketVC: XWHDialContentBaseVC {
    
    private lazy var categories = [XWHDialCategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.clipsToBounds = true

        getMarketCategoryDial()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHDialTitleCTCell.self)
        collectionView.register(cellWithClass: XWHDialCTCell.self)
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dials = categories[section].items
        return dials.count + 1
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
        let cCagegory = categories[indexPath.section]
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withClass:XWHDialTitleCTCell.self, for: indexPath)
            
            cell.update(cCagegory)
            
            cell.clickAction = { [unowned self] in
                self.gotoMore(cCagegory)
            }
            
            return cell
        }
        
        let cDial = cCagegory.items[indexPath.item - 1]
        let cell = collectionView.dequeueReusableCell(withClass: XWHDialCTCell.self, for: indexPath)
        
        cell.update(cDial)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            return
        }
        
        let cCagegory = categories[indexPath.section]
        let cDial = cCagegory.items[indexPath.item - 1]
        gotoDialDetail(cDial)
    }
    
}

// MARK: - Api
extension XWHDialMarketVC {
    
    private func getMarketCategoryDial() {
        XWHProgressHUD.show(title: nil)
        XWHDialVM().getMarketDialCategory(deviceSn: deviceSn) { [weak self] error in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            self.view.makeInsetToast(error.message)
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let cCategories = response.data as? [XWHDialCategoryModel] else {
                self.view.makeInsetToast("数据解析错误")
                return
            }
            
            self.categories = cCategories
            self.collectionView.reloadData()
        }
    }
    
}


// MARK: - Jump
extension XWHDialMarketVC {
    
    private func gotoDialDetail(_ dial: XWHDialModel) {
        let vc = XWHDialDetailVC()
        vc.dial = dial
        vc.deviceSn = deviceSn
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gotoMore(_ category: XWHDialCategoryModel) {
        let vc = XWHDialMoreVC()
        vc.category = category
        vc.deviceSn = deviceSn
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
