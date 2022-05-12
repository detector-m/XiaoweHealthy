//
//  XWHMarkerView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/12.
//

import UIKit

class XWHMarkerView: XWHBaseView {

    lazy var contentView = UIView()
    lazy var textLb = UILabel()
    lazy var detailLb = UILabel()
    
    lazy var lineView = UIView()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.backgroundColor = bgColor.cgColor
        addSubview(contentView)
        
        lineView.backgroundColor = bgColor
        addSubview(lineView)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        textLb.textAlignment = .left
        addSubview(textLb)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textAlignment = .left
        addSubview(detailLb)
    }
    
    override func relayoutSubViews() {
        contentView.snp.makeConstraints { make in
            make.width.equalTo(135)
            make.height.equalTo(67)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        textLb.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.left.right.equalTo(contentView).inset(6)
            make.top.equalTo(contentView).inset(11)
        }
        
        detailLb.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.left.right.equalTo(textLb)
        }
    }

}
