//
//  XWHMePopupContentBaseView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHMePopupContentBaseView: XWHBaseView {

    enum ActionType {
        case cancel
        case confirm
    }

    lazy var titleLb = UILabel()
    
    lazy var cancelBtn = UIButton()
    lazy var confirmBtn = UIButton()
    
    var clickCallback: ((ActionType) -> Void)?
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.textColor = fontDarkColor
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        titleLb.textAlignment = .center
        addSubview(titleLb)
        
        cancelBtn.setTitle(R.string.xwhDisplayText.取消(), for: .normal)
        cancelBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        cancelBtn.setTitleColor(fontDarkColor, for: .normal)
        cancelBtn.layer.cornerRadius = 24
        cancelBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.05)?.cgColor
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        addSubview(cancelBtn)
        
        confirmBtn.setTitle(R.string.xwhDisplayText.确定(), for: .normal)
        confirmBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        confirmBtn.layer.cornerRadius = 24
        confirmBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn), for: .touchUpInside)
        addSubview(confirmBtn)
        
        titleLb.isHidden = true
    }
    
    override func relayoutSubViews() {
        
    }
        
    final func relayoutCancelConfirmButton() {
        cancelBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(snp.centerX).offset(-6)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.height.width.equalTo(cancelBtn)
        }
    }
    
    @objc func clickCancelBtn() {
        if let callback = clickCallback {
            callback(.cancel)
        }
    }
    
    @objc func clickConfirmBtn() {
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
}
