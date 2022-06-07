//
//  XWHRegisterFillInfoBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHRegisterFillInfoBaseVC: XWHRegisterBaseVC {
    
    lazy var preBtn = UIButton()
    lazy var nextBtn = UIButton()
    
    lazy var userModel = XWHUserModel()
    
    // 是否是更新信息
    var isUpdate: Bool = false
    var updateCallback: ((XWHUserModel) -> Void)?

    override func addSubViews() {
        super.addSubViews()
        
        subLb.text = R.string.xwhDisplayText.为了保证运动数据准确请填写个人信息()
        
        preBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        preBtn.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        preBtn.setTitle(R.string.xwhDisplayText.上一步(), for: .normal)
        preBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.04)?.cgColor
        preBtn.layer.cornerRadius = 24
        preBtn.addTarget(self, action: #selector(clickBtnAction(sender:)), for: .touchUpInside)
        view.addSubview(preBtn)
        
        nextBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
//        nextBtn.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        nextBtn.setTitle(R.string.xwhDisplayText.下一步(), for: .normal)
        nextBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        nextBtn.layer.cornerRadius = 24
        nextBtn.addTarget(self, action: #selector(clickBtnAction(sender:)), for: .touchUpInside)
        view.addSubview(nextBtn)
    }
    
    override func clickNavGlobalBackBtn() {
        if isUpdate {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func clickBtnAction(sender: UIButton) {

    }
    
    func layoutPreNextBtn() {
        preBtn.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(view.snp.centerX).offset(-6)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(6)
            make.right.equalToSuperview().inset(24)
            make.bottom.height.equalTo(preBtn)
        }
    }
    
    final func relayoutUpdateConfirmBtn() {
        preBtn.isHidden = true
        nextBtn.setTitle(R.string.xwhDisplayText.确定(), for: .normal)
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
        }
    }

}
