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
        R.string.xwhDisplayText.个人资料()
    }
    
    lazy var tbFooter = XWHTBButtonFooter(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 160)))
    
    lazy var userModel: XWHUserModel = {
        var user: XWHUserModel = XWHUserModel()
        if let cUser = XWHUserDataManager.getCurrentUser() {
            user = cUser
        }
        
        return user
    }()

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
    
    override func addSubViews() {
        super.addSubViews()

        tableView.tableFooterView = tbFooter
        tbFooter.button.setTitle(R.string.xwhDisplayText.保存(), for: .normal)
        DispatchQueue.main.async { [unowned self] in
            self.tbFooter.relayoutSubViews(leftRightInset: 50, bottomInset: 40, height: 50)
        }
        tbFooter.clickCallback = { [unowned self] in
            self.updatePersonInfo()
        }
    }
    
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
        
        if indexPath.row == 0 { // 头像
            cell.titleLb.text = "头像"
            cell.subTitleLb.text = ""
        } else if indexPath.row == 1 { // 性别
            cell.titleLb.text = "性别"
            cell.subTitleLb.text = userModel.genderType.name
        } else if indexPath.row == 2 { // 昵称
            cell.titleLb.text = "昵称"
            cell.subTitleLb.text = userModel.nickname
        } else if indexPath.row == 3 { // 身高
            cell.titleLb.text = "身高"
            cell.subTitleLb.text = userModel.height.string + "CM"
        } else if indexPath.row == 4 { // 体重
            cell.titleLb.text = "体重"
            cell.subTitleLb.text = userModel.weight.string + "KG"
        } else if indexPath.row == 5 { // 出生年份
            cell.titleLb.text = "出生年份"
            cell.subTitleLb.text = userModel.birthday
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
        if indexPath.row == 0 { // 头像
            
        } else if indexPath.row == 1 { // 性别
            gotoSelectGender()
        } else if indexPath.row == 2 { // 昵称
            
        } else if indexPath.row == 3 { // 身高
            gotoSelectHeight()
        } else if indexPath.row == 4 { // 体重
            gotoSelectWeight()
        } else if indexPath.row == 5 { // 出生年份
            gotoSelectBirthday()
        }
    }
    
}


// MARK: - UI Jump & Api
extension XWHPersonInfoTBVC {
    
    /// 选择性别
    private func gotoSelectGender() {
        let vc = XWHGenderSelectVC()
        vc.userModel = userModel
        vc.isUpdate = true
        
        vc.updateCallback = { [weak self] cUserModel in
            self?.userModel.gender = cUserModel.gender
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择身高
    private func gotoSelectHeight() {
        let vc = XWHHeightSelectVC()
        vc.userModel = userModel
        vc.isUpdate = true
        
        vc.updateCallback = { [weak self] cUserModel in
            self?.userModel.height = cUserModel.height
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择体重
    private func gotoSelectWeight() {
        let vc = XWHWeightSelectVC()
        vc.userModel = userModel
        vc.isUpdate = true
        
        vc.updateCallback = { [weak self] cUserModel in
            self?.userModel.weight = cUserModel.weight
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择出生
    private func gotoSelectBirthday() {
        let vc = XWHBirthdaySelectVC()
        vc.userModel = userModel
        vc.isUpdate = true
        
        vc.updateCallback = { [weak self] cUserModel in
            self?.userModel.birthday = cUserModel.birthday
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 更新用户信息
    private func updatePersonInfo() {
        XWHUserVM().update(userModel: userModel)
        XWHUserDataManager.saveUser(&userModel)
    }
    
}
