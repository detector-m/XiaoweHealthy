//
//  XWHMeMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHMeMainVC: XWHTableViewBaseVC {
    
    override var topContentInset: CGFloat {
        66
    }
    
    override var titleText: String {
        R.string.xwhDisplayText.我的()
    }
    
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
    
    @objc private func clickNavRightItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        setNavHidden(true, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        setLargeTitleMode()

        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        largeTitleView.backgroundColor = tableView.backgroundColor
        
        largeTitleView.titleLb.text = titleText
    }
    
    override func relayoutSubViews() {
        relayoutCommon()
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
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = meItems[section][row]
        
        if item.type == .login {
            let cell = tableView.dequeueReusableCell(withClass: XWHMeNormalTBCell.self, for: indexPath)
            cell.titleLb.text = "未登录"
            
            return cell
        } else if item.type == .profile {
            let cell = tableView.dequeueReusableCell(withClass: XWHMeProfileTBCell.self, for: indexPath)
            cell.titleLb.text = XWHDataUserManager.getCurrentUser()?.nickname ?? ""
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHMeNormalTBCell.self, for: indexPath)
            cell.titleLb.text = item.title
            
            return cell
        }
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

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = collectionBgColor
        
        return cView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let item = meItems[section][row]
        
        switch item.type {
        case .login:
            XWHLogin.present(at: self)
            
        case .profile:
            break
            
        case .data:
            break
            
        case .info:
            break
            
        case .settings:
            XWHUser.logout()
            
            reloadAll()
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
        meItems = XWHMeDeploy().loadDeploys(isLogin: XWHUser.isLogined)
        tableView.reloadData()
    }
    
}

// MARK: - UI Jump
extension XWHMeMainVC {
    
    
    
}
