//
//  XWHMeMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHMeMainVC: XWHTableViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var topContentInset: CGFloat {
        66
    }
    
    override var titleText: String {
        R.string.xwhDisplayText.我的()
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.type = .axial
        return gradientLayer
    }()
    private lazy var gradientColors: [UIColor] = [UIColor(hex: 0xD5F9E1)!, UIColor(hex: 0xF8F8F8)!]
    
    private lazy var meItems = [[XWHMeDeployItemModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadAll()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)
        
        let leftItem = getNavItem(text: titleText, font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
        navigationItem.leftBarButtonItem = leftItem
        
//        let rightImage = UIImage.iconFont(text: XWHIconFontOcticons.addCircle.rawValue, size: 24, color: fontDarkColor)
//        let rightItem = getNavItem(text: nil, image: rightImage, target: self, action: #selector(clickNavRightItem))
//        navigationItem.rightBarButtonItem = rightItem
        
        setNavHidden(false, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    @objc private func clickNavLeftItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        setNavHidden(true, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        setLargeTitleMode()

        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        largeTitleView.backgroundColor = tableView.backgroundColor
        
        largeTitleView.titleLb.text = titleText
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
        tableView.register(cellWithClass: XWHMeNormalTBCell.self)
        
        tableView.register(cellWithClass: XWHMeProfileTBCell.self)
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadAll()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHMeMainVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return meItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = meItems[section][row]
        
        if item.type == .profile {
            return 84
        }
        
        return 62
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = meItems[section][row]
        
        if item.type == .profile {
            let cell = tableView.dequeueReusableCell(withClass: XWHMeProfileTBCell.self, for: indexPath)
            if let user = XWHUserDataManager.getCurrentUser() {
                cell.titleLb.text = XWHUserDataManager.getCurrentUser()?.nickname ?? ""
                cell.iconView.kf.setImage(with: user.avatar.url, placeholder: R.image.sport_avatar())
            } else {
                cell.titleLb.text = "未登录"
                cell.iconView.image = R.image.sport_avatar()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHMeNormalTBCell.self, for: indexPath)
            cell.titleLb.text = item.title
            cell.iconView.image = UIImage(named: item.iconImageName)
            
            return cell
        }
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = .clear
        
        return cView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = meItems[section][row]
        
        switch item.type {
        case .profile:
            gotoPersonInfo()
            
        case .settings:
            gotoPersonSettings()
            
        case .feedback:
            gotoQuestionFeedback()
            
        case .appUpdate:
            gotoAppUpdate()
        
        case .about:
            gotoAboutApp()
            
//        default:
//            gotoPersonHealthDatas()
        }
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}

// MARK: - UI
extension XWHMeMainVC {
    
    private func reloadAll() {
        meItems = XWHMeDeploy().loadDeploys()
        tableView.reloadData()
    }
    
}

// MARK: - UI Jump
extension XWHMeMainVC {
    
    /// 我的数据
    private func gotoPersonHealthDatas() {
        if !XWHUser.isLogined {
            XWHLogin.present(at: self)
            return
        }
        
        let vc = XWHPersonHealthDatasTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 意见反馈
    private func gotoQuestionFeedback() {
        let vc = XWHQuestionFeedbackCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到个人信息
    private func gotoPersonInfo() {
        if !XWHUser.isLogined {
            XWHLogin.present(at: self)
            return
        }
        
        let vc = XWHPersonInfoTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 设置
    private func gotoPersonSettings() {
        if !XWHUser.isLogined {
            XWHLogin.present(at: self)
            return
        }
        
        let vc = XWHPersonSettingsTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 版本更新
    private func gotoAppUpdate() {
        UIApplication.shared.open(kAppDownloadUrl.url!)
    }
    
    /// 关于
    private func gotoAboutApp() {
        let vc = XWHAboutAppVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
