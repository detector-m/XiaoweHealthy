//
//  XWHSportRecordDetailVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit


/// 运动详情
class XWHSportRecordDetailVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        return "运动详情"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        tableView.frame = CGRect(x: 0, y: 242 + view.safeAreaInsets.top, width: view.width, height: view.height)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        setNav(color: .white)
        navigationItem.title = titleText
        
        let rightItem = getNavItem(text: nil, image: R.image.share_icon(), target: self, action: #selector(clickShareBtn))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func clickShareBtn() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = btnBgColor
        tableView.separatorStyle = .none
    }
    
    override func relayoutSubViews() {
        tableView.frame = CGRect(x: 0, y: 240, width: view.width, height: view.height)
    }
    
    override func registerViews() {
        
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportRecordDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let section = indexPath.section
//        let row = indexPath.row
         
        return 71
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
         
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 0.001
        }
        
        return 12
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return nil
        }
        let cView = UIView()
        cView.backgroundColor = collectionBgColor

        return cView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = collectionBgColor

        return cView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var sOffset = scrollView.contentOffset.y
        
        if sOffset >= 242 {
            sOffset = 242
        } else if sOffset <= 0 {
            sOffset = 0
        }
        
        tableView.frame = CGRect(x: 0, y: 242 + view.safeAreaInsets.top - sOffset, width: view.width, height: view.height)
    }
    
}
