//
//  XWHLargeTitleView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/19.
//

import UIKit

class XWHLargeTitleView: XWHBaseView {

    lazy var titleLb = UILabel()
//    lazy var detailLb = UILabel()
//    lazy var button = UIButton()
    
    override func addSubViews() {
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = fontDarkColor
        titleLb.textAlignment = .left
        titleLb.adjustsFontSizeToFitWidth = true
        titleLb.baselineAdjustment = .alignBaselines
        addSubview(titleLb)
        
//        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.contentHorizontalAlignment = .right
//        button.setTitleColor(fontDarkColor, for: .normal)
//        addSubview(button)
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(28)
        }
    }

}
