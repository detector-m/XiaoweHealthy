//
//  XWHSportRecordListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit

class XWHSportRecordListTBVC: XWHTableViewBaseVC {
    
    private lazy var topBgView = UIView()
    
    lazy var titleBtn: UIButton = {
        let _titleBtn = UIButton()
        _titleBtn.frame = CGRect(x: 0, y: 0, width: 160, height: 44)
        _titleBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .medium)
        _titleBtn.setTitleColor(fontDarkColor, for: .normal)
        _titleBtn.addTarget(self, action: #selector(clickTitleBtn), for: .touchUpInside)
        
        return _titleBtn
    }()
    
    lazy var allSummaryView = XWHSRLAllRecordSummaryView()
    
    /// ["2022-06-24": true]
//    private lazy var expandStates: [String: Bool] = [:]
    
    private(set) lazy var openImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 16, color: fontDarkColor)
    
    private lazy var expandStates: [Bool] = []
    private lazy var dataItems: [String] = []
    
    lazy var sIndex: Int = 0
    lazy var sportItems: [XWHSportType] = [.none, .run, .walk, .ride, .climb]
    lazy var filterSportNames: [String] = [R.string.xwhSportText.所有运动(), R.string.xwhSportText.跑步(), R.string.xwhSportText.步行(), R.string.xwhSportText.骑行(), R.string.xwhSportText.爬山()]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if titleBtn.isSelected {
            return .default
        }
        
        if tableView.contentOffset.y <= allSummaryView.height - view.safeAreaInsets.top {
            return .lightContent
        }
        
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataItems = ["2022-07", "2022-06", "2022-05", "2022-04", "2022-03"]
        expandStates = dataItems.map({ _ in false })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let c = CGRect(x: 0, y: 0, width: view.width, height: 172 + self.view.safeAreaInsets.top)
        self.allSummaryView.frame = c
        DispatchQueue.main.async {
            self.allSummaryView.relayoutSubViews(topInset: self.view.safeAreaInsets.top)
            self.allSummaryView.update()
            self.tableView.tableHeaderView = self.allSummaryView
            self.tableView.reloadData()
        }
    }
    
    override func setupNavigationItems() {
        /// 下拉时
        var leftItem: UIBarButtonItem
        if tableView.contentOffset.y <= allSummaryView.height - view.safeAreaInsets.top {
            leftItem = getNavItem(text: nil, image: R.image.globalBack()?.tint(.white, blendMode: .destinationIn), target: self, action: #selector(clickNavGlobalBackBtn))
            titleBtn.setTitleColor(.white, for: .normal)
            setNav(color: UIColor(hex: 0x354152)!)
        } else {
            leftItem = getNavGlobalBackItem()
            titleBtn.setTitleColor(fontDarkColor, for: .normal)
            setNav(color: .white)
        }
        
        updateTitleBtn()

        navigationItem.leftBarButtonItem = leftItem
        rt_disableInteractivePop = false
        
        navigationItem.titleView = titleBtn
    }
    
    private func updateTitleBtn() {
        let titleText = filterSportNames[sIndex]
        let cColor = titleBtn.titleColorForNormal ?? fontDarkColor
        titleBtn.set(image: openImage.tint(cColor, blendMode: .destinationIn), title: titleText, titlePosition: .left, additionalSpacing: 5, state: .normal)
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
        
        topBgView.frame = CGRect(x: 0, y: -view.height, width: view.width, height: view.height)
        view.addSubview(topBgView)
        
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        topBgView.backgroundColor = view.backgroundColor
        
        view.sendSubviewToBack(topBgView)
    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.top.equalToSuperview()
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
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupNavigationItems()
        if scrollView.contentOffset.y <= allSummaryView.height - view.safeAreaInsets.top {
            let cColor = UIColor(hex: 0x354152)!
            setNav(color: cColor)
            topBgView.backgroundColor = cColor
            
            topBgView.y = -topBgView.height - scrollView.contentOffset.y
        } else {
            setNav(color: .white)
            topBgView.backgroundColor = view.backgroundColor
        }
    }
    
}


// MARK: - UI Jump
extension XWHSportRecordListTBVC {
    
    /// 运动详情
    private func gotoSportRecordDetail() {
        let vc = XWHSportRecordDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
