//
//  XWHQuestionTagCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit

class XWHQuestionTagCTCell: XWHBaseCTCell {
    
    lazy var btn1 = UIButton()
    lazy var btn2 = UIButton()
    lazy var btn3 = UIButton()
    
    lazy var tagIndex = 0
    
    override func addSubViews() {
        contentView.addSubview(textLb)
        
        contentView.addSubview(btn1)
        contentView.addSubview(btn2)
        contentView.addSubview(btn3)
        
        let btnFont = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        btn1.titleLabel?.font = btnFont
        btn2.titleLabel?.font = btnFont
        btn3.titleLabel?.font = btnFont
        
        btn1.setTitleColor(fontDarkColor, for: .normal)
        btn1.layer.cornerRadius = 14
        btn1.tag = 0
        
        btn2.setTitleColor(fontDarkColor, for: .normal)
        btn2.layer.cornerRadius = 14
        btn2.tag = 1

        btn3.setTitleColor(fontDarkColor, for: .normal)
        btn3.layer.cornerRadius = 14
        btn3.tag = 2
        
        let btnInsets = UIEdgeInsets(horizontal: 12, vertical: 0)
        btn1.contentEdgeInsets = btnInsets
        btn2.contentEdgeInsets = btnInsets
        btn3.contentEdgeInsets = btnInsets
        
        updateTags()
        
        btn1.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        btn3.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        
        btn1.setTitle("功能异常", for: .normal)
        btn2.setTitle("意见与建议", for: .normal)
        btn3.setTitle("其他", for: .normal)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        let redColor = UIColor(hex: 0xF5222D)!
        textLb.attributedText = "问题类型：".colored(with: fontDarkColor.withAlphaComponent(0.5)) + "*".colored(with: redColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)], toOccurrencesOf: "*")
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
        
        btn1.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(28)
            make.left.equalToSuperview().inset(12)
            make.top.equalTo(textLb.snp.bottom).offset(12)
        }
        btn2.snp.makeConstraints { make in
//            make.width.lessThanOrEqualTo(50)
            make.width.height.top.equalTo(btn1)
            make.left.equalTo(btn1.snp.right).offset(10)
        }
        btn3.snp.makeConstraints { make in
            make.width.height.top.equalTo(btn1)
            make.left.equalTo(btn2.snp.right).offset(10)
        }
    }
    
    @objc private func clickBtn(sender: UIButton) {
        tagIndex = sender.tag
        updateTags()
    }
    
    private func updateTags() {
        let sColor = UIColor(hex: 0xCFCFCF)!
        let nColor = UIColor(hex: 0xF7F7F7)!
        
        if tagIndex == 0 {
            btn1.layer.backgroundColor = sColor.cgColor
            btn2.layer.backgroundColor = nColor.cgColor
            btn3.layer.backgroundColor = nColor.cgColor
        } else if tagIndex == 1 {
            btn1.layer.backgroundColor = nColor.cgColor
            btn2.layer.backgroundColor = sColor.cgColor
            btn3.layer.backgroundColor = nColor.cgColor
        } else {
            btn1.layer.backgroundColor = nColor.cgColor
            btn2.layer.backgroundColor = nColor.cgColor
            btn3.layer.backgroundColor = sColor.cgColor
        }
    }
    
}
