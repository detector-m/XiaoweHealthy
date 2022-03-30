//
//  XWHCommonBaseTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import UIKit

class XWHCommonBaseTBCell: XWHBaseTBCell {
    
    lazy var subIconView = UIImageView()
    lazy var subTitleLb = UILabel()

    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(subIconView)
        
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        subTitleLb.textColor = UIColor(hex: 0x000000, transparency: 0.27)
        subTitleLb.textAlignment = .right
        contentView.addSubview(subTitleLb)
    
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        subIconView.image = UIImage.iconFont(text: XWHIconFontOcticons.cellArrowRight.rawValue, size: 18, color: UIColor(hex: 0x000000, transparency: 0.15) ?? .black)
    }

}
