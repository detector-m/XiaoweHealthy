//
//  XWHMeMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHMeMainVC: XWHTableViewBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        setLargeTitleMode()

        view.backgroundColor = bgColor
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        largeTitleView.backgroundColor = tableView.backgroundColor
        
        largeTitleView.titleLb.text = R.string.xwhDisplayText.我的()
    }
    
    override func relayoutSubViews() {
        relayoutCommon()
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHBaseTBCell.self)
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHMeMainVC {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHBaseTBCell.self, for: indexPath)
        if XWHUser.isLogined {
            cell.titleLb.text = "退出登录"
        } else {
            cell.titleLb.text = "未登录"
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
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if XWHUser.isLogined {
            XWHUser.logout()
            
            tableView.reloadData()
        }
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}
