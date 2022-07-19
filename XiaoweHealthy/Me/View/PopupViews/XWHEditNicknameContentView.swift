//
//  XWHEditNicknameContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHEditNicknameContentView: XWHMePopupContentBaseView {
    
    private var textBgView = UIView()
    lazy var textFiled = TextFieldCounter(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 112 - 32, height: 52), limit: 20, animate: true, ascending: true, counterColor: fontDarkColor.withAlphaComponent(0.25), limitColor: fontDarkColor.withAlphaComponent(0.25))

    lazy var nickname = ""

    override func addSubViews() {
        super.addSubViews()
        
        addSubview(textBgView)
        addSubview(textFiled)

        textBgView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.03).cgColor
        textBgView.layer.cornerRadius = 16
        
        textFiled.borderStyle = .none
        textFiled.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
        textFiled.counterLabel.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
        
        textFiled.backgroundColor = .clear
        textFiled.layer.borderWidth = 0
        textFiled.layer.cornerRadius = 0
        textFiled.layer.borderColor = nil
        
        textFiled.tintColor = btnBgColor
        textFiled.placeholder = "请输入昵称"
        
        titleLb.isHidden = false
        
        titleLb.text = "昵称"
        titleLb.textAlignment = .center
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(27)
            make.left.right.equalToSuperview().inset(20)
        }
        
        textBgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLb.snp.bottom).offset(24)
            make.height.equalTo(52)
        }
        textFiled.snp.makeConstraints { make in
            make.left.right.equalTo(textBgView).inset(16)
            make.center.equalTo(textBgView)
        }
        relayoutCancelConfirmButton()
    }
    
    override func clickConfirmBtn() {
        guard let tfText = textFiled.text, !tfText.isEmpty else {
            return
        }
        
        if nickname == tfText {
            return
        }
        
        nickname = tfText
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
    func update(nickname: String) {
        self.nickname = nickname
        textFiled.text = nickname
    }

}
