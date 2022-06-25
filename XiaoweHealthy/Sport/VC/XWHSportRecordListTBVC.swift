//
//  XWHSportRecordListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit

class XWHSportRecordListTBVC: XWHTableViewBaseVC {
    
    lazy var titleBtn = UIButton()
    
    /// ["2022-06-24": true]
//    private lazy var expandStates: [String: Bool] = [:]
    
    private(set) lazy var openImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 16, color: fontDarkColor)
    
    
    private lazy var expandStates: [Bool] = []
    private lazy var dataItems: [String] = []
    
    lazy var sIndex: Int = 0
    lazy var sportItems: [XWHSportType] = [.none, .run, .walk, .ride, .climb]
    lazy var filterSportNames: [String] = [R.string.xwhSportText.所有运动(), R.string.xwhSportText.跑步(), R.string.xwhSportText.步行(), R.string.xwhSportText.骑行(), R.string.xwhSportText.爬山()]

    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if !titleBtn.isSelected {
//            return .lightContent
//        }
        
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataItems = ["2022-07", "2022-06", "2022-05", "2022-04", "2022-03"]
        expandStates = dataItems.map({ _ in false })
        tableView.reloadData()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        setNav(color: .white)
        
        titleBtn.frame = CGRect(x: 0, y: 0, width: 160, height: 44)
        titleBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .medium)
        titleBtn.setTitleColor(fontDarkColor, for: .normal)
        titleBtn.addTarget(self, action: #selector(clickTitleBtn), for: .touchUpInside)
        
        updateTitleBtn()
        
        navigationItem.titleView = titleBtn
    }
    
    private func updateTitleBtn() {
        let titleText = filterSportNames[sIndex]
        titleBtn.set(image: openImage, title: titleText, titlePosition: .left, additionalSpacing: 5, state: .normal)
    }
    
    @objc private func clickTitleBtn() {
        titleBtn.isSelected = !titleBtn.isSelected
        setNeedsStatusBarAppearanceUpdate()
        XWHPopupSportFilter.show(pickItems: filterSportNames, sIndex: sIndex) { [unowned self] aType, row in
            self.titleBtn.isSelected = !self.titleBtn.isSelected
            
            self.setNeedsStatusBarAppearanceUpdate()

            if aType == .cancel {
            } else {
                self.sIndex = row
                self.updateTitleBtn()
            }
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = collectionBgColor
        tableView.separatorStyle = .none
        
        let allSummaryView = XWHSRLAllRecordSummaryView()
        allSummaryView.frame = CGRect(x: -16, y: 0, width: view.width, height: 172)
        allSummaryView.update()
        tableView.tableHeaderView = allSummaryView
    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHSRLSectionHeaderTBCell.self)
        tableView.register(cellWithClass: XWHSRLSportRecordSummaryTBCell.self)

        tableView.register(cellWithClass: XWHSRLSportRecordTBCell.self)        
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportRecordListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return expandStates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isExpand = expandStates[section]
        
        if isExpand {
            return 4 + 1
        } else {
           return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let section = indexPath.section
//        let row = indexPath.row
         
        return 71
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
         
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSRLSectionHeaderTBCell.self, for: indexPath)

            cell.titleLb.text = dataItems[section]
            let isExpand = expandStates[section]
            cell.isOpen = isExpand

            return cell
        } else if row == 1 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSRLSportRecordSummaryTBCell.self, for: indexPath)
            cell.update()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHSRLSportRecordTBCell.self, for: indexPath)
            
            cell.update()
            
            return cell
        }
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
        if indexPath.row  == 0 {
            expandStates[indexPath.section] = !expandStates[indexPath.section]
            tableView.reloadData()
        } else if indexPath.row == 1 {
            
        } else {
            gotoSportRecordDetail()
        }
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
