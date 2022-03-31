//
//  XWHDevSetSwitchTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetSwitchTBCell: XWHCommonBaseTBCell {

    lazy var button = UIButton()
    
    var clickAction: ((Bool) -> Void)?

    override func addSubViews() {
        super.addSubViews()
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
//        button.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
//        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        contentView.addSubview(button)
                
        iconView.isHidden = true
        subIconView.isHidden = true
        
        subTitleLb.numberOfLines = 2
        subTitleLb.textAlignment = .left
        
        button.setImage(R.image.switchOff(), for: .normal)
        button.setImage(R.image.switchOn(), for: .selected)
    }
    
    override func relayoutSubViews() {
        relayoutTitleSubTitleLb()
    }
    
    @objc func clickButton() {
        button.isSelected = !button.isSelected
        clickAction?(button.isSelected)
    }
    
    func relayoutTitleSubTitleLb() {
        titleLb.isHidden = false
        subTitleLb.isHidden = false
        
        relayoutButton()
        
        titleLb.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(button.snp.left).offset(-6)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(24)
        }
        
        subTitleLb.snp.remakeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(2)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func relayoutTitleLb() {
        titleLb.isHidden = false
        subTitleLb.isHidden = true
        
        relayoutButton()
        
        titleLb.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(button.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func relayoutButton() {
        button.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

}
