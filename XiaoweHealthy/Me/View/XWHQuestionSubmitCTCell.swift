//
//  XWHQuestionSubmitCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit

class XWHQuestionSubmitCTCell: XWHButtonCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        button.setTitle("提交", for: .normal)
    }
    
    override func relayoutSubViews() {
        relayoutSubViews(leftRightInset: 12, bottomInset: 80, height: 48)
    }

}
