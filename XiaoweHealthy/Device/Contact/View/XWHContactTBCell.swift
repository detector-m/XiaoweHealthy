//
//  XWHContactTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit

class XWHContactTBCell: XWHComLineBaseTBCell {
    
    lazy var textIcon = UILabel()
    
    private lazy var uncheckImage: UIImage = {
        UIImage.iconFont(text: XWHIconFontOcticons.uncheck.rawValue, size: 24, color: fontLightColor.withAlphaComponent(0.2))
    }()
    
    private lazy var checkImage: UIImage = {
        UIImage.iconFont(text: XWHIconFontOcticons.checkBg.rawValue, size: 24, color: btnBgColor)
    }()

    override func addSubViews() {
        super.addSubViews()
        iconView.isHidden = true
        
        textIcon.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        textIcon.textColor = fontLightLightColor
        
        textIcon.layer.cornerRadius = 18
        textIcon.layer.backgroundColor = UIColor(hex: 0x6AACF7)?.withAlphaComponent(0.5).cgColor
        
        textIcon.textAlignment = .center
        contentView.addSubview(textIcon)
    }
    
    override func relayoutSubViews() {
        textIcon.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.left.equalToSuperview().offset(28)
            make.centerY.equalToSuperview()
        }
        
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-28)
        }
        
        titleLb.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(4)
            make.left.equalTo(textIcon.snp.right).offset(17)
            make.right.lessThanOrEqualTo(subIconView.snp.left).offset(-10)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.equalTo(titleLb.snp.bottom).offset(2)
            make.left.equalTo(textIcon.snp.right).offset(17)
            make.right.lessThanOrEqualTo(subIconView.snp.left).offset(-10)
        }
        
        relayoutTopBottomLine()
    }
    
    func update(contact: XWHDevContactModel) {
        titleLb.text = contact.name
        subTitleLb.text = contact.number
        textIcon.text = contact.name.last?.string ?? ""
        subIconView.image = contact.isSelected ? checkImage : uncheckImage
    }

}
