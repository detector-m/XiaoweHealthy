//
//  XWHSelectContactVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit
import SwiftyContacts


class XWHSelectContactVC: XWHContactBaseVC {
    
    private let maxCount = 100
    private lazy var curCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNav(color: bgColor)
        title = R.string.xwhContactText.选择手机联系人()
        
        loadContacts()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        textField.textColor = fontLightColor
        textField.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        textField.tintColor = btnBgColor
        textField.layer.cornerRadius = 12
        textField.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.03)?.cgColor
        textField.placeholder = R.string.xwhContactText.搜索联系人()
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textColor = fontDarkColor
        titleLb.text = R.string.xwhContactText.全选()
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.setTitle(R.string.xwhContactText.同步到设备N(), for: .normal)
        
        allSelectBtn.titleLabel?.font = UIFont.iconFont(size: 24)
        allSelectBtn.setTitle(XWHIconFontOcticons.uncheck.rawValue, for: .normal)
        allSelectBtn.setTitle(XWHIconFontOcticons.checkBg.rawValue, for: .selected)
        allSelectBtn.setTitleColor(fontLightColor.withAlphaComponent(0.2), for: .normal)
        allSelectBtn.setTitleColor(btnBgColor, for: .selected)
        allSelectBtn.addTarget(self, action: #selector(clickAllSelectBtn), for: .touchUpInside)
//        view.addSubview(allSelectBtn)
        
        updateBeforeSyncUI()
    }
    
    override func relayoutSubViews() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(28)
        }
        allSelectBtn.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(26)
        }
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(textField)
            make.right.lessThanOrEqualTo(allSelectBtn.snp.left).offset(-10)
            make.centerY.equalTo(allSelectBtn)
            make.height.equalTo(52)
        }
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom)
            make.bottom.equalTo(button.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHContactTBCell.self)
    }
    
    @objc override func clickButton() {
        if curCount == 0 {
            return
        }
        
        updateSyncUI()
        sendContacts()
    }
    
    @objc override func clickAllSelectBtn() {
        
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
        
        cell.bottomLine.isHidden = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            cell.bottomLine.isHidden = true
        }
        
        cell.update(contact: contacts[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cModel = contacts[indexPath.row]
        if curCount == maxCount, !cModel.isSelected {
            view.makeInsetToast("已到达100个了，无法再添加")
            return
        }
        cModel.isSelected = !cModel.isSelected
        if let cell = tableView.cellForRow(at: indexPath) as? XWHContactTBCell {
            cell.update(contact: cModel)
        }
        updateBeforeSyncUI()
    }

}


// MARK: - Data
extension XWHSelectContactVC {
    
    private func loadContacts() {
        fetchContacts { [unowned self] result in
            switch result {
            case let .success(contacts):
                self.parseCNContacts(contacts)
                self.tableView.reloadData()
                
            case let .failure(error):
                log.error(error.localizedDescription)
            }
        }
    }
    
    private func parseCNContacts(_ cnContacts: [CNContact]) {
        contacts = cnContacts.map { (cModel: CNContact) -> XWHDevContactModel in
            let con = XWHDevContactModel()
            con.name = cModel.givenName
            con.number = cModel.phoneNumbers.first?.value.stringValue ?? ""
            if con.name.isEmpty {
                con.name = con.number
            }
            
            return con
        }
    }
    
}

// MARK: - UI
extension XWHSelectContactVC {
    
    private func updateBeforeSyncUI() {
        button.isEnabled = true
        curCount = contacts.count(where: { $0.isSelected })
        
        let cText = "\(curCount)/\(maxCount)"
        let bTitle = R.string.xwhContactText.同步到设备N().replacingOccurrences(of: "N", with: cText)
        button.setTitle(bTitle, for: .normal)
    }
    
    private func updateSyncUI() {
        button.isEnabled = false
        let bTitle = R.string.xwhContactText.同步中()
        button.setTitle(bTitle, for: .normal)
    }
    
    private func updateAfterSyncUI() {
        button.isEnabled = false
        let bTitle = R.string.xwhContactText.同步完成()
        button.setTitle(bTitle, for: .normal)
    }
    
}

// MARK: - Api
extension XWHSelectContactVC {
    
    private func sendContacts() {
        let selectedContacts = contacts.filter({ $0.isSelected })
        XWHDDMShared.sendContact(selectedContacts) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                ddManager.deleteCurrentContacts()
                ddManager.saveCurrentContacts(selectedContacts)
                self.updateAfterSyncUI()
                
            case .failure(_):
                self.updateBeforeSyncUI()
                self.view.makeInsetToast("同步联系人失败")
            }
        }
    }
    
}
