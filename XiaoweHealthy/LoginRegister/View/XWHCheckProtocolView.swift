//
//  XWHCheckProtocolView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit
import ActiveLabel

class XWHCheckProtocolView: XWHTextFieldBaseView {

//    lazy var checkBtn = UIButton()
    lazy var protocolLb = ActiveLabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        button.setImage(R.image.uncheckIcon(), for: .normal)
        button.setImage(R.image.checkIcon(), for: .selected)
//        button.addTarget(self, action: #selector(clickCheckBtn), for: .touchUpInside)
//        addSubview(checkBtn)
        
        let customType1 = ActiveType.custom(pattern: "\\\(R.string.xwhDisplayText.用户协议())")
        let customType2 = ActiveType.custom(pattern: "\\\(R.string.xwhDisplayText.隐私政策())")
        protocolLb.enabledTypes = [customType1, customType2]
        protocolLb.numberOfLines = 2
        protocolLb.text = R.string.xwhDisplayText.我已阅读并同意用户协议隐私政策首次登录将自动创建小维健康账号()
        protocolLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        protocolLb.customColor[customType1] = UIColor(hex: 0x2DC84D)
        protocolLb.customColor[customType2] = UIColor(hex: 0x2DC84D)
        protocolLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        protocolLb.handleCustomTap(for: customType1, handler: { (customType) in

        })
        protocolLb.handleCustomTap(for: customType2, handler: { (customType) in

        })
        
        addSubview(protocolLb)
    }
    
    override func relayoutSubViews() {
        button.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.left.top.equalTo(0)
        }
        
        protocolLb.snp.makeConstraints { make in
            make.left.equalTo(button.snp.right).offset(6)
            make.top.right.equalToSuperview()
            make.height.equalTo(34)
        }
    }
    
    @objc override func clickButton() {
        button.isSelected = !button.isSelected
    }

}
