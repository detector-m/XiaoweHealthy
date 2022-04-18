//
//  XWHContactFilterView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/18.
//

import UIKit

class XWHContactFilterView: XWHBaseView, UITableViewDataSource, UITableViewDelegate {

    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    lazy var button = UIButton()
    lazy var tipLb = UILabel()
    
    lazy var filterContacts = [XWHDevContactModel]()
    var selectedContacts: [XWHDevContactModel] {
        filterContacts.filter({ $0.isSelected })
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        backgroundColor = bgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bgColor
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.separatorStyle = .none
                
        addSubview(tableView)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.setTitle(R.string.xwhContactText.确定选择(), for: .normal)
        addSubview(button)
        
        tipLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
        tipLb.textColor = fontDarkColor
        tipLb.textAlignment = .center
        tipLb.isHidden = true
        addSubview(tipLb)
        
        registerViews()
    }
    
    override func relayoutSubViews() {
        tipLb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(button.snp.top).offset(-16)
        }
    }

    
    @objc private func clickButton() {
        
    }
    
    func registerViews() {
        tableView.register(cellWithClass: XWHContactTBCell.self)
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterContacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHContactTBCell.self, for: indexPath)
        
        cell.bottomLine.isHidden = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            cell.bottomLine.isHidden = true
        }
        
        cell.update(contact: filterContacts[indexPath.row])

        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cModel = filterContacts[indexPath.row]
        cModel.isSelected = !cModel.isSelected
        if let cell = tableView.cellForRow(at: indexPath) as? XWHContactTBCell {
            cell.update(contact: cModel)
        }
    }

    
    // MARK: - Method
    func update(_ contacts: [XWHDevContactModel], _ text: String) {
        filterContacts = contacts
        
        tableView.reloadData()
        
        if contacts.isEmpty {
            tipLb.text = R.string.xwhContactText.抱歉没有找到关于N的联系人().replacingOccurrences(of: "N", with: text)
            tipLb.isHidden = false
        } else {
            tipLb.isHidden = true
        }
        
        button.isHidden = !tipLb.isHidden
    }
    
    
}
