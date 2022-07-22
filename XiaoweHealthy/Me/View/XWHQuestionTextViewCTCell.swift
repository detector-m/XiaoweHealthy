//
//  XWHQuestionTextViewCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit
import KMPlaceholderTextView

class XWHQuestionTextViewCTCell: XWHBaseCTCell {
    
    lazy var textViewBgView = UIView()
    lazy var textView = KMPlaceholderTextView()
    lazy var countLb = UILabel()
    
    private let maxNumberOfWords = 500
    
    override func addSubViews() {
        contentView.addSubview(textViewBgView)
        contentView.addSubview(textLb)
        contentView.addSubview(textView)
        contentView.addSubview(countLb)
        
        textViewBgView.layer.cornerRadius = 16
        textViewBgView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.03).cgColor
        
        textView.placeholder = "反馈您的问题和建议，我们会尽快处理回复并且不断改进"
        textView.placeholderColor = fontDarkColor.withAlphaComponent(0.3)
        
        textView.tintColor = btnBgColor
        textView.backgroundColor = .clear
        
        textView.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        
//        textView.layer.cornerRadius = 16
//        textView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.03).cgColor
        
        textView.delegate = self
        
        countLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        countLb.textAlignment = .right
        countLb.textColor = fontDarkColor.withAlphaComponent(0.3)
        
        textViewDidChange(textView)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        let redColor = UIColor(hex: 0xF5222D)!
        textLb.attributedText = "问题描述或建议：".colored(with: fontDarkColor.withAlphaComponent(0.5)) + "*".colored(with: redColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)], toOccurrencesOf: "*")
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
        
        textViewBgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(textLb.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(textViewBgView).inset(12)
        }
        
        countLb.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(textView)
            make.height.equalTo(19)
        }
    }
    
}

extension XWHQuestionTextViewCTCell: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        countLb.text = "\(textView.text.count)/\(maxNumberOfWords)"
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let oldText = textView.text as NSString
        let newText = oldText.replacingCharacters(in: range, with: text)
        
        if newText.count > maxNumberOfWords {
            return false
        } else {
            return true
        }
    }

}
