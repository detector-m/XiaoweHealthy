//
//  XWHContactEntryVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit

class XWHContactEntryVC: XWHSearchBindDevBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhContactText.联系人()
        detailLb.isHidden = true
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 12)
        button.setTitleColor(fontDarkColor.withAlphaComponent(0.3), for: .normal)
        button.layer.backgroundColor = dialBarBgColor.cgColor
        button.layer.cornerRadius = 16
        let iconImage = UIImage.iconFont(text: XWHIconFontOcticons.addBg.rawValue, size: 36, color: dialBarBgColor)
        button.setImage(iconImage, for: .normal)
        button.setTitle(R.string.xwhContactText.添加联系人(), for: .normal)
        button.centerTextAndImage(imageAboveText: true, spacing: 6)
    }
    
    override func relayoutSubViews() {
        relayoutTitleLb()
        
        button.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.height.equalTo(118)
        }
    }
    
    @objc override func clickButton() {
        
    }

}
