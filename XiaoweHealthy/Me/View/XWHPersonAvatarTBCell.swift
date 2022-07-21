//
//  XWHPersonAvatarTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPersonAvatarTBCell: XWHBaseTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        iconView.layer.cornerRadius = 85.cgFloat / 2
        iconView.layer.masksToBounds = true
        
        iconView.contentMode = .scaleAspectFit
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 11, weight: .medium)
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.textAlignment = .center
        titleLb.text = "点击设置头像"
    }

    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(85)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(iconView.snp.bottom).offset(2)
            make.height.equalTo(22)
        }
    }

}
