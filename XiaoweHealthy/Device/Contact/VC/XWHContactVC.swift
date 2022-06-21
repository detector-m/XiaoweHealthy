//
//  XWHContactVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit
import SwiftyContacts

class XWHContactVC: XWHContactBaseVC {
    
    override var isSearchMode: Bool {
        didSet {
            filterView.isHidden = !isSearchMode
            setupNavRightItem()
        }
    }
    
    lazy var allSelectLb = UILabel()
    private var isCanDelete: Bool {
        if uiEditState == .delete {
            let selectedCount = contacts.count(where: { $0.isSelected })
            if selectedCount > 0 {
                return true
            }
        }
        
        return false
    }
    
    private var isAll: Bool {
        if uiEditState == .delete {
            for iModel in contacts {
                if !iModel.isSelected {
                    return false
                }
            }
            return true
        }
        
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    private func setupNavRightItem() {
//        if contacts.isEmpty || isSearchMode {
//            navigationItem.rightBarButtonItem = nil
//            return
//        }
//        
//        switch uiEditState {
//        case .normal:
//            let rightItem = getNavItem(text: nil, image: UIImage.iconFont(text: XWHIconFontOcticons.delete.rawValue, size: 24, color: fontDarkColor), target: self, action: #selector(clickNavRightItem))
//            navigationItem.rightBarButtonItem = rightItem
//            
//        case .delete:
//            let rightItem = getNavItem(text: nil, image: UIImage.iconFont(text: XWHIconFontOcticons.finish.rawValue, size: 24, color: fontDarkColor), target: self, action: #selector(clickNavRightItem))
//            navigationItem.rightBarButtonItem = rightItem
//        }
    }
    
    @objc private func clickNavRightItem() {
        if uiEditState == .normal {
            uiEditState = .delete
        } else {
            uiEditState = .normal
            contacts.forEach({ $0.isSelected = false })
        }
        
        setupNavRightItem()
        updateContactUI()
        relayoutContact()
        tableView.reloadData()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhContactText.联系人()
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = fontDarkColor
        
        allSelectLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        allSelectLb.textColor = fontDarkColor
        allSelectLb.text = R.string.xwhContactText.全选()
        view.addSubview(allSelectLb)
        
        view.bringSubviewToFront(filterView)
        
        allSelectBtn.setTitleColor(.red, for: .selected)
    }
    
    private func updateNoContactUI() {
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 12)
        button.setTitleColor(fontDarkColor.withAlphaComponent(0.3), for: .normal)
        button.layer.backgroundColor = dialBarBgColor.cgColor
        button.layer.cornerRadius = 16
        let iconImage = UIImage.iconFont(text: XWHIconFontOcticons.addBg.rawValue, size: 36, color: dialBarBgColor)
        button.setImage(iconImage, for: .normal)
        button.setTitle(R.string.xwhContactText.添加联系人(), for: .normal)
        button.centerTextAndImage(imageAboveText: true, spacing: 6)
    }
    
    private func relayoutNoContact() {
        textField.isHidden = true
        allSelectBtn.isHidden = true
        tableView.isHidden = true
        
        relayoutTitleLb()
        
        button.snp.remakeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.height.equalTo(118)
        }
    }
    
    private func updateContactUI() {
        if uiEditState == .normal {
            updateContactNormalUI()
        } else {
            updateContactDeleteUI()
        }
    }
    
    private func updateContactNormalUI() {
        filterView.isDelete = false
        filterView.isCanSelected = false
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.setTitle(R.string.xwhContactText.添加联系人(), for: .normal)
    }
    
    private func updateContactDeleteUI() {
        filterView.isDelete = true
        filterView.isCanSelected = true
        
        if isCanDelete {
            button.setTitleColor(UIColor.red, for: .normal)
            button.layer.backgroundColor = UIColor(hex: 0xEEEEEE)!.cgColor
        } else {
            button.setTitleColor(fontLightLightColor, for: .normal)
            button.layer.backgroundColor = btnDisableBgColor.cgColor
        }
        
        button.layer.cornerRadius = 24
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitle(R.string.xwhContactText.删除(), for: .normal)
    }
    
    private func relayoutContact() {
        if uiEditState == .normal {
            relayoutNormalUI()
        } else {
            relayoutDeleteUI()
        }
    }
    
    override func relayoutSubViews() {
        relayoutTitleLb()
    }
    
    private func relayoutNormalUI() {
        allSelectBtn.isHidden = true
        allSelectLb.isHidden = true
        
        button.isHidden = false
        tableView.isHidden = false
        
        button.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        
        textField.snp.remakeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(28)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.bottom.equalTo(button.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    private func relayoutDeleteUI() {
        allSelectBtn.isHidden = false
        allSelectLb.isHidden = false
        
        button.isHidden = false
        tableView.isHidden = false
        
        button.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        
        textField.snp.remakeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(28)
        }
        
        allSelectBtn.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(26)
        }
        allSelectLb.snp.makeConstraints { make in
            make.left.equalTo(textField)
            make.right.lessThanOrEqualTo(allSelectBtn.snp.left).offset(-10)
            make.centerY.equalTo(allSelectBtn)
            make.height.equalTo(52)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(allSelectLb.snp.bottom).offset(16)
            make.bottom.equalTo(button.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHContactTBCell.self)
    }
    
    @objc override func clickButton() {
        if uiEditState == .normal {
            requestAccess { [weak self] result in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    switch result {
                    case let .success(isOk):
                        if isOk {
                            self.gotoSelectContact()
                        } else {
                            self.gotoShowContactPermission()
                        }
                        
                    case let .failure(error):
                        log.error(error.localizedDescription)
                        
                        //                let status = authorizationStatus()
                        //                log.debug(status == CNAuthorizationStatus.authorized)
                        self.gotoShowContactPermission()
                    }
                }
            }
        } else {
            if isCanDelete {
                XWHAlert.show(message: R.string.xwhContactText.删除后手表同步也会清除确认删除这些联系人嘛()) { [unowned self] aType in
                    if aType == .confirm {
                        self.contacts.removeAll(where: { $0.isSelected})
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc override func clickAllSelectBtn() {
        if allSelectBtn.isSelected {
            contacts.forEach({ $0.isSelected = false })
        } else {
            contacts.forEach({ $0.isSelected = true })
        }
        
        allSelectBtn.isSelected = !allSelectBtn.isSelected
        updateContactDeleteUI()
        tableView.reloadData()
    }
    
    @objc override func textFiledChanged(sender: UITextField) {
        super.textFiledChanged(sender: sender)
        
        let text = sender.text ?? ""
        let searchContacts = filterContacts(text)
        filterView.update(searchContacts, text)
    }
    
    @objc override func clickTFRightBtn() {
        super.clickTFRightBtn()
        
        tableView.reloadData()
    }
    @objc override func clickFilterConfirm() {
        super.clickFilterConfirm()
        textField.text = nil
        
        updateTextFieldRightBtn(textField)

        if uiEditState == .normal {
            return 
        }
        
        let selecteds = filterView.selectedContacts
        if selecteds.isEmpty {
            return
        }
        
        outBreak: for aModel in contacts {
            if contacts.count(where: { $0.isSelected }) == maxCount {
                break outBreak
            }
            for bModel in selecteds {
                if aModel.name == bModel.name, aModel.number == bModel.number {
                    aModel.isSelected = true
                }
            }
        }
        
        updateContactDeleteUI()
        tableView.reloadData()
    }
    
    // MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadContacts()
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHContactTBCell.self, for: indexPath)
        if uiEditState == .delete {
            cell.subIconView.isHidden = false
        } else {
            cell.subIconView.isHidden = true
        }
        
        cell.bottomLine.isHidden = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            cell.bottomLine.isHidden = true
        }
        
        cell.update(contact: contacts[indexPath.row], isDelete: (uiEditState == .delete))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if uiEditState == .delete {
            let cModel = contacts[indexPath.row]
            cModel.isSelected = !cModel.isSelected
            if let cell = tableView.cellForRow(at: indexPath) as? XWHContactTBCell {
                cell.update(contact: cModel, isDelete: true)
            }
            updateContactDeleteUI()
            if isCanDelete, isAll {
                allSelectBtn.isSelected = true
            } else {
                allSelectBtn.isSelected = false
            }
        }
    }

}

// MARK: - Data
extension XWHContactVC {
    
    private func loadContacts() {
        contacts = ddManager.getCurrentContacts() ?? []
        setupNavRightItem()
        if contacts.isEmpty {
            updateNoContactUI()
            relayoutNoContact()
        } else {
            updateContactUI()
            relayoutContact()
            tableView.reloadData()
        }
    }
    
}


// MARK: - Jump VC
extension XWHContactVC {
    
    private func gotoShowContactPermission() {
        XWHAlert.show(title: nil, message: R.string.xwhContactText.需要联系人权限以获取联系人()) { aType in
            if aType == .confirm {
                RLBLEPermissions.openAppSettings()
            }
        }
    }
    
    private func gotoSelectContact() {
        let vc = XWHSelectContactVC()
        vc.savedContacts = contacts
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
