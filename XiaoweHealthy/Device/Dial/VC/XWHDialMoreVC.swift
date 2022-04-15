//
//  XWHDialMoreVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit
import Pageboy

class XWHDialMoreVC: XWHMyDialVC {

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
        XWHDialVM().getMarketCategoryDial(categoryId: 1, deviceSn: "1923190012204123456", page: page, pageSize: pageSize) { [unowned self] error in
            XWHProgressHUD.hide()
            self.view.makeInsetToast(error.message)
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
        }
    }
    
}
