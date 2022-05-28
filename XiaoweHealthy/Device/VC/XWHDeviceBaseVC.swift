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
        
        setNavTransparent()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = fontDarkColor
        view.addSubview(titleLb)
        
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        detailLb.textColor = fontDarkColor
        view.addSubview(detailLb)
    }
    
    func relayoutTitleAndDetailLb() {
//        titleLb.snp.makeConstraints { make in
//            make.top.equalTo(74)
//            make.height.equalTo(40)
//
//            make.left.right.equalToSuperview().inset(28)
//        }
        relayoutTitleLb()
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.height.equalTo(20)
        }
    }
    
    func relayoutTitleLb() {
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(6)
            make.height.equalTo(40)

            make.left.right.equalToSuperview().inset(28)
        }
    }

}
