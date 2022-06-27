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
    
    private var tbXOffset: CGFloat {
        16
    }
    private var tbWidth: CGFloat {
        view.width - tbXOffset * 2
    }
    private var tbHeigth: CGFloat {
        view.height - view.safeAreaInsets.top
    }
    private var safeAreaTop: CGFloat {
        view.safeAreaInsets.top
    }
    private var topOffset: CGFloat {
        242
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        tableView.frame = CGRect(x: tbXOffset, y: safeAreaTop + topOffset, width: tbWidth, height: tbHeigth)
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
    }
    
    override func relayoutSubViews() {
//        tableView.frame = CGRect(x: 0, y: 240, width: view.width, height: view.height)
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHSportDetailSummaryTBCell.self)
        tableView.register(cellWithClass: XWHSportDetailDataDetailTBCell.self)
        tableView.register(cellWithClass: XWHSportDetailPaceTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportRecordDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
//        let row = indexPath.row

        if section == 0 {
            return 300
        } else if section == 1 {
            return 291
        } else {
            return 481
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
//        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSportDetailSummaryTBCell.self)
            cell.update()
            
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSportDetailPaceTBCell.self)
            cell.update()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHSportDetailDataDetailTBCell.self)
            cell.update()
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 0.001
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section != 0 {
//            return nil
//        }
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sOffset = scrollView.contentOffset.y
        
        if sOffset > 0 {
            if tableView.y == safeAreaTop {
                return
            }
            
            scrollView.touchesShouldCancel(in: scrollView)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) { [weak self] in
                guard let self = self else {
                    return
                }
                self.tableView.frame = CGRect(x: self.tbXOffset, y: self.safeAreaTop, width: self.tbWidth, height: self.tbHeigth)
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            } completion: { _ in }
        } else if sOffset < -64 {
            if tableView.y == topOffset + safeAreaTop {
                return
            }
            
            scrollView.touchesShouldCancel(in: scrollView)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) { [weak self] in
                guard let self = self else {
                    return
                }
                self.tableView.frame = CGRect(x: self.tbXOffset, y: self.topOffset + self.safeAreaTop, width: self.tbWidth, height: self.tbHeigth)
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            } completion: { _ in }
        }
        
//        if sOffset >= 242 {
//            sOffset = 242
//        } else if sOffset <= 0 {
//            sOffset = 0
//        }
//
//        tableView.frame = CGRect(x: 0, y: 242 + view.safeAreaInsets.top - sOffset, width: view.width, height: view.height)
    }
    
}
