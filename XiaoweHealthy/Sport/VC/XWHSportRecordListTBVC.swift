//
//  XWHSportRecordListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit

class XWHSportRecordListTBVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        return R.string.xwhSportText.运动记录()
    }
    
    private var srItems: [XWHSRListDeployItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        srItems = XWHSportRecordListDeploy().loadDeploys(rawData: [])
        tableView.reloadData()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        setNav(color: .white)
        
        navigationItem.title = titleText
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        tableView.separatorStyle = .none
    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHSRLSportRecordTBCell.self)        
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportRecordListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return srItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sItem = srItems[section]
        return sItem.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
         
        let iItem = srItems[section].items[row]
        
        if iItem.type == .sportRecordHeader {
            return 90
        }
        
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
         
        let iItem = srItems[section].items[row]
        
        let cell = tableView.dequeueReusableCell(withClass: XWHSRLSportRecordTBCell.self, for: indexPath)

        if iItem.type == .sportRecordHeader {
            cell.titleLb.text = "标题 \(section)-\(row)"
        }
        
        if iItem.type == .sportRecord {
            cell.titleLb.text = "运动 \(section)-\(row)"
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
        gotoSportRecordDetail()
    }
    
    // MARK: - UIScrollViewDeletate
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        handleScrollLargeTitle(in: scrollView)
//    }
    
}


// MARK: - UI Jump
extension XWHSportRecordListTBVC {
    
    /// 运动详情
    private func gotoSportRecordDetail() {
        let vc = XWHSportRecordDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
