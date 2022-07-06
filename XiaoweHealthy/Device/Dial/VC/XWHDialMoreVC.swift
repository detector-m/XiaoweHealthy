//
//  XWHDialMoreVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit
import Pageboy
import MJRefresh

class XWHDialMoreVC: XWHMyDialVC {
    
    override var pageSize: Int {
        20
    }
    
    lazy var category = XWHDialCategoryModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
    }
    
    override func setupNavigationItems() {
        navigationItem.leftBarButtonItem = getNavGlobalBackItem()
        rt_disableInteractivePop = false
    }
    
    override func addHeaderRefresh() {
         refreshHeader =  collectionView.addHeader(contentInsetTop: 0, contentOffset: 0) { [weak self] in
             guard let self = self else {
                 return
             }
             
             self.page = 1
             self.refreshFooter?.resetNoMoreData()
             self.getDialsFromServer()
        }
    }
    
    override func addFooterRefresh() {
        refreshFooter = collectionView.addFooter { [weak self] in
            guard let self = self else {
                return
            }
            
            self.getDialsFromServer()
        }
    }
    
    override func getDialsFromServer() {
        getMarketCategoryDial()
    }

}

// MARK: - Api
extension XWHDialMoreVC {
    
    private func getMarketCategoryDial() {
        if page == 1 {
            XWHProgressHUD.show(title: nil)
        }
        XWHDialVM().getMarketCategoryDial(categoryId: category.categoryId, deviceSn: deviceSn, page: page, pageSize: pageSize) { [weak self] error in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            self.refreshHeader?.endRefreshing()
            self.refreshFooter?.endRefreshing()
            
            self.view.makeInsetToast(error.message)
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            self.refreshHeader?.endRefreshing()
            self.refreshFooter?.endRefreshing()
            
            guard let cDials = response.data as? [XWHDialModel] else {
                self.view.makeInsetToast("数据解析错误")
                
                return
            }
            
            if self.page == 1 {
                self.dials.removeAll()
            }
            
            self.dials.append(contentsOf: cDials)
            
            if cDials.count < self.pageSize {
                self.refreshFooter?.endRefreshingWithNoMoreData()
            } else {
                self.page += 1
            }
            
            if self.dials.isEmpty {
                self.removeFooterRefresh()
            }
            self.collectionView.reloadData()
        }
    }
    
}
