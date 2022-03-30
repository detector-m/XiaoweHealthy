//
//  XWHDeviceMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHDeviceMainVC: XWHSearchBindDevBaseVC {
    
    lazy var tableView = UITableView()
    
    private lazy var deviceItems = [[XWHDeployItemModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configDeviceItems()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = UIColor(hex: 0xF8F8F8)
        
        configTableView()
        view.addSubview(tableView)
        
        detailLb.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.我的设备()
        
        button.titleLabel?.font = UIFont.iconFont(size: 24)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(XWHIconFontOcticons.addCircle.rawValue, for: .normal)
        button.layer.backgroundColor = nil
        button.layer.cornerRadius = 0
    }
    
    override func relayoutSubViews() {
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.size.equalTo(24)
            make.top.equalToSuperview().offset(74)
        }
        
        titleLb.snp.makeConstraints { make in
            make.centerY.equalTo(button)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(button.snp.left)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

// MARK: - Config Data
extension XWHDeviceMainVC {
    
    private func configDeviceItems() {
        deviceItems = XWHDeviceDeploy().loadDeploys()
    }
    
}

// MARK: - ConfigUI
extension XWHDeviceMainVC {
    
    private func configTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDeviceNormallTBCell.self)
    }
    
}

// MARK: - UI
extension XWHDeviceMainVC {
    
    private func reloadAll() {
        configDeviceItems()
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource,
extension XWHDeviceMainVC: UITableViewDataSource, UITableViewDelegate, UITableViewRoundedProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return deviceItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceItems[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = deviceItems[section][row]
        
        let cell = tableView.dequeueReusableCell(withClass: XWHDeviceNormallTBCell.self)
        
        cell.iconView.image = UIImage(named: item.iconImageName)
        cell.iconView.layer.backgroundColor = item.iconBgColor?.cgColor
        cell.titleLb.text = item.title
        cell.subTitleLb.text = item.subTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = UIColor(hex: 0xF8F8F8)
        
        return cView
    }
    
}
