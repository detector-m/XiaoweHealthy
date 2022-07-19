//
//  XWHPersonInfoTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHPersonInfoTBVC: XWHTableViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var topContentInset: CGFloat {
        66
    }
    
    override var titleText: String {
        R.string.xwhDisplayText.基本信息()
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
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)
        
//        let leftItem = getNavItem(text: titleText, font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
//        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.title = titleText
        
//        setNavHidden(false, animated: true, async: false)
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.title = ""
        
//        setNavHidden(true, animated: true, async: false)
    }
    
    override func addSubViews() {
        super.addSubViews()

        setLargeTitleMode()

        largeTitleView.titleLb.text = titleText
        
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = collectionBgColor
        
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = tbFooter
        tbFooter.button.setTitle(R.string.xwhDisplayText.保存(), for: .normal)
        DispatchQueue.main.async { [unowned self] in
            self.tbFooter.relayoutSubViews(leftRightInset: 12, bottomInset: 40, height: 50)
        }
        tbFooter.clickCallback = { [unowned self] in
            self.updatePersonInfo()
        }
    }
    
    override func relayoutSubViews() {
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitle()
        relayoutLargeTitleContentView()
    }
    
    override func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(12)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(12)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHPersonAvatarTBCell.self)

        tableView.register(cellWithClass: XWHPersonInfoTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHPersonInfoTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 153
        }
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHPersonAvatarTBCell.self, for: indexPath)
            
            cell.iconView.kf.setImage(with: userModel.avatar.url, placeholder: R.image.sport_avatar())
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: XWHPersonInfoTBCell.self, for: indexPath)
        
        cell.bottomLine.isHidden = false
        if indexPath.row == 0 { // 昵称
            cell.titleLb.text = "昵称"
            cell.subTitleLb.text = userModel.nickname
        } else if indexPath.row == 1 { // 性别
            cell.titleLb.text = "性别"
            cell.subTitleLb.text = userModel.genderType.name
        } else if indexPath.row == 2 { // 身高
            cell.titleLb.text = "身高"
            cell.subTitleLb.text = userModel.height.string + "CM"
        } else if indexPath.row == 3 { // 体重
            cell.titleLb.text = "体重"
            cell.subTitleLb.text = userModel.weight.string + "KG"
        } else if indexPath.row == 4 { // 出生年份
            cell.titleLb.text = "出生年份"
            cell.subTitleLb.text = userModel.birthday
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       if indexPath.section == 0 {
           return
       }
       rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            return
        }
        
        if indexPath.row == 0 { // 昵称
            gotoSetNickname()
        } else if indexPath.row == 1 { // 性别
            gotoSelectGender()
        } else if indexPath.row == 2 { // 身高
            gotoSelectHeight()
        } else if indexPath.row == 3 { // 体重
            gotoSelectWeight()
        } else if indexPath.row == 4 { // 出生年份
            gotoSelectBirthday()
        }
    }
    
}


// MARK: - UI Jump & Api
extension XWHPersonInfoTBVC {
    
    /// 设置昵称
    private func gotoSetNickname() {
        XWHEditNicknamePopupView.show(nickname: userModel.nickname) { [weak self] cNickname in
            guard let self = self else {
                return
            }
            
            self.userModel.nickname = cNickname
            self.tableView.reloadData()
        }
    }
    
    /// 选择性别
    private func gotoSelectGender() {
//        let vc = XWHGenderSelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.gender = cUserModel.gender
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickGenderPopupView.showPickGender(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.gender = cUserModel.gender
            self.tableView.reloadData()
        }
    }
    
    /// 选择身高
    private func gotoSelectHeight() {
//        let vc = XWHHeightSelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.height = cUserModel.height
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickHeightPopupView.showPickHeight(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.height = cUserModel.height
            self.tableView.reloadData()
        }
    }
    
    /// 选择体重
    private func gotoSelectWeight() {
//        let vc = XWHWeightSelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.weight = cUserModel.weight
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickWeightPopupView.showPickWeight(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.weight = cUserModel.weight
            self.tableView.reloadData()
        }
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
