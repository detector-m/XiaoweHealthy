//
//  XWHContactBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit

class XWHContactBaseVC: XWHTableViewBaseVC {
    
    lazy var textField = UITextField()
    lazy var titleLb = UILabel()
    lazy var button = UIButton()
    
    lazy var allSelectBtn = UIButton()
    
    lazy var contacts = [XWHDevContactModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        textField.textColor = fontLightColor
        textField.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        textField.tintColor = btnBgColor
        textField.layer.cornerRadius = 12
        textField.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.03)?.cgColor
        textField.placeholder = R.string.xwhContactText.搜索联系人()
        textField.leftView = UIView()
        view.addSubview(textField)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textColor = fontDarkColor
        titleLb.text = R.string.xwhContactText.全选()
        view.addSubview(titleLb)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.setTitle(R.string.xwhContactText.同步到设备N(), for: .normal)
        view.addSubview(button)
        
        allSelectBtn.titleLabel?.font = UIFont.iconFont(size: 24)
        allSelectBtn.setTitle(XWHIconFontOcticons.uncheck.rawValue, for: .normal)
        allSelectBtn.setTitle(XWHIconFontOcticons.checkBg.rawValue, for: .selected)
        allSelectBtn.setTitleColor(fontLightColor.withAlphaComponent(0.2), for: .normal)
        allSelectBtn.setTitleColor(btnBgColor, for: .selected)
        allSelectBtn.addTarget(self, action: #selector(clickAllSelectBtn), for: .touchUpInside)
        view.addSubview(allSelectBtn)
        
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    override func relayoutSubViews() {
        
    }
    
    func relayoutTitleLb() {
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(74)
            make.height.equalTo(40)

            make.left.right.equalToSuperview().inset(28)
        }
    }
    
    @objc func clickButton() {
        
    }
    
    @objc func clickAllSelectBtn() {
        
    }

}
