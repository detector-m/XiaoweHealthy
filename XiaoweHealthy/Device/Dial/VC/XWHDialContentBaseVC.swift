//
//  XWHDialContentBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHDialContentBaseVC: XWHCollectionViewBaseVC {
    
    // 设备标识
    lazy var deviceSn: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav(color: bgColor)
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func relayoutSubViews() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview()
        }
    }

}
