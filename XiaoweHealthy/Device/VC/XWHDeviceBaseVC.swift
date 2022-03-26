//
//  XWHDeviceBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/25.
//

import UIKit

class XWHDeviceBaseVC: XWHBaseVC {
    
    lazy var titleLb = UILabel()
    lazy var detailLb = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        view.addSubview(titleLb)
        
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        detailLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        view.addSubview(detailLb)
    }

}
