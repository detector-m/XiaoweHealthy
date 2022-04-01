//
//  XWHDevSetUpdateVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import UIKit

class XWHDevSetUpdateVC: XWHDevSetBaseVC {
    
    lazy var headerView = XWHDevSetUpdateHeaderView()
    
    lazy var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
    
        view.addSubview(headerView)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        view.addSubview(button)

        titleLb.text = R.string.xwhDeviceText.检查更新()
        
        button.setTitle(R.string.xwhDeviceText.下载升级包N(), for: .normal)
    }
    
    override func relayoutSubViews() {
        relayoutTitleLb()
        headerView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(40)
            make.height.equalTo((80 + 6 + 48))
            make.left.right.equalToSuperview().inset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(button.snp.top)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHBaseTBCell.self)
        
        tableView.register(headerFooterViewClassWith: XWHTBHeaderFooterBaseView.self)
    }
    
    @objc func clickButton() {
        
    }
    

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHBaseTBCell.self)
        cell.titleLb.text =  "\(indexPath.row + 1)、\(String.random(ofLength: 32))"
        cell.titleLb.numberOfLines = 0
        cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        cell.relayoutOnlyTitleLb()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withClass: XWHTBHeaderFooterBaseView.self)
        header.titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        header.titleLb.textColor = fontDarkColor
        header.titleLb.text = R.string.xwhDeviceText.固件更新日志()
        
        return header
    }

}
