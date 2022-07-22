//
//  XWHQuestionTextViewCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit

class XWHQuestionTextViewCTCell: XWHBaseCTCell {
    
    override func addSubViews() {
        contentView.addSubview(textLb)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        let redColor = UIColor(hex: 0xF5222D)!
        textLb.attributedText = "问题描述或建议：".colored(with: fontDarkColor.withAlphaComponent(0.5)) + "*".colored(with: redColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)], toOccurrencesOf: "*")
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
    }
    
}
