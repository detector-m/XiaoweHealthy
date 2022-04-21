//
//  XWHBaseCTReusableView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHBaseCTReusableView: UICollectionReusableView {
    
//    lazy var imageView = UIImageView()
    lazy var textLb = UILabel()
    lazy var button = UIButton()
    
    var clickAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addSubViews() {
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        addSubview(textLb)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 12)
        button.setTitleColor(fontLightColor, for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        addSubview(button)
    }
    
    @objc func relayoutSubViews() {
        relayoutLeftRight()
    }
    
    @objc func relayoutLeftRight(_ inset: CGFloat = 0) {
//        button.contentHorizontalAlignment = .right
        
        button.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(inset)
            make.left.greaterThanOrEqualTo(snp.centerX)
        }
        textLb.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(inset)
            make.right.lessThanOrEqualTo(button.snp.left).offset(-10)
        }
    }
    
    @objc func clickButton() {
        clickAction?()
    }
    
}
