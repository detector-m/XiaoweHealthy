//
//  XWHContactVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit
import SwiftyContacts

class XWHContactVC: XWHContactBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContacts()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhContactText.联系人()
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = fontDarkColor
    }
    
    override func relayoutSubViews() {
        relayoutNoContact()
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHContactTBCell.self)
    }
    
    @objc override func clickButton() {
        requestAccess { [unowned self] result in
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
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHContactTBCell.self, for: indexPath)
        
        cell.subIconView.isHidden = true
        
        cell.bottomLine.isHidden = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            cell.bottomLine.isHidden = true
        }
        
        cell.update(contact: contacts[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}

// MARK: - Data
extension XWHContactVC {
    
    private func loadContacts() {
        contacts = ddManager.getCurrentContacts() ?? []
        if contacts.isEmpty {
            noContactUI()
            relayoutNoContact()
        } else {
            contactUI()
            relayoutContact()
            tableView.reloadData()
        }
    }
    
}

// MARK: - UI
extension XWHContactVC {
    
    private func noContactUI() {
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
    
    private func contactUI() {
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.setTitle(R.string.xwhContactText.添加联系人(), for: .normal)
    }
    
    private func relayoutContact() {
        button.isHidden = false
        tableView.isHidden = false
        
        button.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.bottom.equalTo(button.snp.top)
            make.left.right.equalToSuperview()
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
