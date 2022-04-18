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
    
    // 是否是搜索模式
    lazy var isSearchMode = false
    lazy var searchContacts = [XWHDevContactModel]()
    
    lazy var uiEditState = XWHUIEditState.normal

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
        let leftView = UIView(frame: CGRect(center: .zero, size: CGSize(width: 16, height: 16)))
        textField.leftViewMode = .always
        textField.leftView = leftView
//        textField.clearButtonMode = .never
        let rightBtn = UIButton(frame: CGRect(center: .zero, size: CGSize(width: 56, height: 22)))
        rightBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        rightBtn.addTarget(self, action: #selector(clickTFRightBtn), for: .touchUpInside)
        textField.rightView = rightBtn
        textField.rightViewMode = .always
        updateTextFieldRightBtn(textField)
        
        textField.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
        
        textField.addTarget(self, action: #selector(textFiledBegin(sender:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFiledEnd(sender:)), for: .editingDidEnd)

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
    
    @objc func textFiledBegin(sender: UITextField) {
        sender.layer.borderColor = btnBgColor.cgColor
        sender.layer.borderWidth = 1
    }
    
    @objc func textFiledEnd(sender: UITextField) {
        sender.layer.borderColor = nil
        sender.layer.borderWidth = 0
    }
    
    @objc func textFiledChanged(sender: UITextField) {
        updateTextFieldRightBtn(sender)
        
        guard let cText = sender.text else {
            isSearchMode = false
            return
        }
        
        if cText.isEmpty {
            isSearchMode = false
        } else {
            isSearchMode = true
        }
    }
    
    @objc func clickTFRightBtn() {
        isSearchMode = false
        guard let cText = textField.text else {
            return
        }
        
        if cText.isEmpty {
            return
        }
        
        textField.text = nil
        updateTextFieldRightBtn(textField)
    }
    
    @objc func clickAllSelectBtn() {
        
    }
    
    func updateTextFieldRightBtn(_ tf: UITextField) {
        guard let clearBtn = tf.rightView as? UIButton else {
            return
        }
        
        let clearBtnColor = fontLightColor
        let size: CGFloat = 16
        guard let cText = tf.text else {
            clearBtn.setImage(UIImage.iconFont(text: XWHIconFontOcticons.search.rawValue, size: size, color: clearBtnColor), for: .normal)
            return
        }
        
        if cText.isEmpty {
            clearBtn.setImage(UIImage.iconFont(text: XWHIconFontOcticons.search.rawValue, size: size, color: clearBtnColor), for: .normal)
        } else {
            clearBtn.setImage(UIImage.iconFont(text: XWHIconFontOcticons.closeNoBg.rawValue, size: size, color: clearBtnColor), for: .normal)
        }
    }

}

extension XWHContactBaseVC {
    
    func filterContacts(_ text: String) -> [XWHDevContactModel] {
        let filterContacts = contacts.filter { $0.name.contains(text) }
        
        return filterContacts
    }
    
}
