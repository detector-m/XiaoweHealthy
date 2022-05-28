//
//  XWHHealthyMainCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/28.
//

import UIKit

class XWHHealthyMainCommonCTCell: XWHBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        addImageTextView()
        
        backgroundColor = contentBgColor
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 12)
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
}
