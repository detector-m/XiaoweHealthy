//
//  XWHDeviceMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHDeviceMainVC: XWHSearchBindDevBaseVC {
    
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = UIColor(hex: 0xF8F8F8)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
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

// MARK: - UITableViewDataSource,
extension XWHDeviceMainVC: UITableViewDataSource, UITableViewDelegate, UITableViewRoundedProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cCount = arc4random() % 5 + 1
        return Int(cCount)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
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
