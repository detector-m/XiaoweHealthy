//
//  XWHQuestionSubmitCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit

class XWHQuestionSubmitCTCell: XWHBaseCTCell {
    
    lazy var button = UIButton()
    
    var clickCallback: (() -> ())?
    
    override func addSubViews() {
        super.addSubViews()
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        addSubview(button)
        
        button.setTitle("提交", for: .normal)
    }
    
    override func relayoutSubViews() {
        relayoutSubViews(leftRightInset: 12, bottomInset: 80, height: 48)
    }
    
    final func relayoutSubViews(leftRightInset: CGFloat = 0, bottomInset: CGFloat = 0, height: CGFloat = 48) {
        button.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(leftRightInset)
            make.height.equalTo(height)
            make.bottom.equalToSuperview().inset(bottomInset)
        }
    }
    
    @objc func clickButton() {
        clickCallback?()
    }

}
