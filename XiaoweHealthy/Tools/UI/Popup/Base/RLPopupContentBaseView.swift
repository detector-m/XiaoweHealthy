//
//  RLPopupContentBaseView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import UIKit

class RLPopupContentBaseView: UIView {
    
    enum ActionType {
        case cancel
        case confirm
    }

    lazy var titleLb = UILabel()
    lazy var detailLb = UILabel()
    
    lazy var cancelBtn = UIButton()
    lazy var confirmBtn = UIButton()
    
    var clickCallback: ((ActionType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        
        DispatchQueue.main.async { [unowned self] in
            self.relayoutSubViews()
        }
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        titleLb.textAlignment = .center
        addSubview(titleLb)
        
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        detailLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        detailLb.numberOfLines = 0
        addSubview(detailLb)
        
        cancelBtn.setTitle(R.string.xwhDisplayText.取消(), for: .normal)
        cancelBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        cancelBtn.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
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
        detailLb.isHidden = true
    }
    
    @objc func relayoutSubViews() {
//        relayoutForNormal()
        
//        relayoutForNoTitle()
        
//        relayoutForNoTitleCancel()
    }
    
    func relayoutForNormal() {
        titleLb.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(30)
        }
        
        detailLb.snp.remakeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        cancelBtn.snp.remakeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(snp.centerX).offset(-6)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
        
        confirmBtn.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.bottom.height.width.equalTo(cancelBtn)
        }
    }
    
    func relayoutForNoTitle() {
        titleLb.isHidden = true
        
        detailLb.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(24)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        cancelBtn.snp.remakeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(snp.centerX).offset(-6)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
        
        confirmBtn.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.height.width.equalTo(cancelBtn)
        }
    }
    
    func relayoutForNoTitleCancel() {
        titleLb.isHidden = true
        cancelBtn.isHidden = true
        
        detailLb.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(24)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        confirmBtn.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
    }
    
    func relayoutCancelConfirmButton() {
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
    
//    override var intrinsicContentSize: CGSize {
//        let window = UIApplication.shared.keyWindow!
//
//        return CGSize(width: window.width - 24, height: 172)
//    }

}
