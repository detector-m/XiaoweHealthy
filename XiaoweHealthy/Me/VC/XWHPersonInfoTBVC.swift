//
//  XWHPersonInfoTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHPersonInfoTBVC: XWHTableViewBaseVC {
    
    override var topContentInset: CGFloat {
        66
    }
    
    override var titleText: String {
        "个人信息"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNav(color: .white)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.title = titleText
    }
    
//    override func setNavigationBarWithLargeTitle() {
//        setNav(color: .white)
//        navigationItem.title = titleText
//        setNavHidden(false, animated: true, async: false)
//    }
//
//    override func resetNavigationBarWithoutLargeTitle() {
//        setNavTransparent()
//        navigationItem.title = nil
//        setNavHidden(true, animated: true, async: false)
//    }
    
//    override func addSubViews() {
//        super.addSubViews()
//
//        setLargeTitleMode()
//
//        view.backgroundColor = collectionBgColor
//        tableView.backgroundColor = view.backgroundColor
//        tableView.separatorStyle = .none
//        largeTitleView.backgroundColor = tableView.backgroundColor
//
//        largeTitleView.titleLb.text = titleText
//    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHPersonInfoTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHPersonInfoTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHPersonInfoTBCell.self, for: indexPath)
        
        var user: XWHUserModel = XWHUserModel()
        if let cUser = XWHDataUserManager.getCurrentUser() {
            user = cUser
        }
        
        if indexPath.row == 0 { // 头像
            cell.titleLb.text = "头像"
            cell.subTitleLb.text = ""
        } else if indexPath.row == 1 { // 性别
            cell.titleLb.text = "性别"
            cell.subTitleLb.text = user.genderType.name
        } else if indexPath.row == 2 { // 昵称
            cell.titleLb.text = "昵称"
            cell.subTitleLb.text = user.nickname
        } else if indexPath.row == 3 { // 身高
            cell.titleLb.text = "身高"
            cell.subTitleLb.text = user.height.string + "CM"
        } else if indexPath.row == 4 { // 体重
            cell.titleLb.text = "体重"
            cell.subTitleLb.text = user.weight.string + "KG"
        } else if indexPath.row == 5 { // 出生年份
            cell.titleLb.text = "出生年份"
            cell.subTitleLb.text = user.birthday
        }
        
        return cell
    }
    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 12
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
