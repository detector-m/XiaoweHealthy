//
//  XWHDialMoreVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit
import Pageboy

class XWHDialMoreVC: XWHMyDialVC {
    
    lazy var category = XWHDialCategoryModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
    }
    
    override func setupNavigationItems() {
        navigationItem.leftBarButtonItem = getNavGlobalBackItem()
        rt_disableInteractivePop = false
    }
    
    override func getDialsFromServer() {
        getMarketCategoryDial()
    }

}

// MARK: - Api
extension XWHDialMoreVC {
    
    private func getMarketCategoryDial() {
        XWHProgressHUD.show(title: nil)
        XWHDialVM().getMarketCategoryDial(categoryId: category.categoryId, deviceSn: deviceSn, page: page, pageSize: pageSize) { [weak self] error in
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
            
            guard let cDials = response.data as? [XWHDialModel] else {
                self.view.makeInsetToast("数据解析错误")
                return
            }
            
            self.dials = cDials
            self.collectionView.reloadData()
        }
    }
    
}
