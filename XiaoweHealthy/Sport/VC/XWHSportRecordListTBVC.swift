//
//  XWHSportRecordListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit
import MJRefresh

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
    
    private(set) lazy var openImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 16, color: fontDarkColor)
    
    private var refreshFooter: MJRefreshAutoNormalFooter?
    
    var sSportType: XWHSportType {
        get {
            sportItems[sIndex]
        }
        set {
            sIndex = sportItems.firstIndex(of: newValue) ?? 0
        }
    }
    
    private lazy var bYear: Int = Date().year
    private lazy var sYear: Int = bYear
    private lazy var sIndex: Int = 0
    private lazy var sportItems: [XWHSportType] = [.none, .run, .walk, .ride, .climb]
    private lazy var filterSportNames: [String] = [R.string.xwhSportText.所有运动(), R.string.xwhSportText.跑步(), R.string.xwhSportText.步行(), R.string.xwhSportText.骑行(), R.string.xwhSportText.爬山()]
    
    private var sportTotalRecord: XWHSportTotalRecordModel?
    private lazy var sportRecords: [XWHSportMonthRecordModel] = []

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
        
        addFooterRefresh()
//        getSportTotalRecord()
//        getSportRecordList()
        
        syncGetSportRecords()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let c = CGRect(x: 0, y: 0, width: view.width, height: 172 + self.view.safeAreaInsets.top)
        self.allSummaryView.frame = c
        DispatchQueue.main.async {
            self.allSummaryView.relayoutSubViews(topInset: self.view.safeAreaInsets.top)
            self.allSummaryView.update(sTotalRecord: self.sportTotalRecord)
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
                self.sYear = self.bYear
                self.refreshFooter?.resetNoMoreData()
                self.syncGetSportRecords()
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
    
    func addFooterRefresh() {
        refreshFooter = tableView.addFooter { [weak self] in
            guard let self = self else {
                return
            }
            
            self.sYear += 1
            self.getSportRecordList()
        }
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportRecordListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sportRecords.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monthRecord = sportRecords[section]
        let isExpand = monthRecord.isExpand
        
        if isExpand {
            return monthRecord.record.items.count + 2
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
        
        let monthRecord = sportRecords[section]
         
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSRLSectionHeaderTBCell.self, for: indexPath)

            cell.titleLb.text = monthRecord.yearMonth
            cell.isOpen = monthRecord.isExpand

            return cell
        } else if row == 1 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSRLSportRecordSummaryTBCell.self, for: indexPath)
            cell.update(monthRecord: monthRecord)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHSRLSportRecordTBCell.self, for: indexPath)
            
            let sportRecordItem = monthRecord.record.items[row - 2]
            cell.update(recordItem: sportRecordItem)
            
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
        let section = indexPath.section
        let row = indexPath.row
        
        let monthRecord = sportRecords[section]
        
        if indexPath.row  == 0 {
            monthRecord.isExpand = !monthRecord.isExpand
            tableView.reloadData()
        } else if indexPath.row == 1 {
            
        } else {
            let sportRecordItem = monthRecord.record.items[row - 2]
            gotoSportRecordDetail(recordItem: sportRecordItem)
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

// MARK: - Api
extension XWHSportRecordListTBVC {
    
    // 同步获取运动记录
    private func syncGetSportRecords() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "request_queue")
        
        XWHProgressHUD.show()
        
        group.enter()
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.getSportTotalRecord {
                group.leave()
            }
        }
        
        group.enter()
        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.getSportRecordList {
                group.leave()
            }
        }
        
        group.notify(queue: queue) { [weak self] in
            guard let _ = self else {
                return
            }
            
            DispatchQueue.main.async {
                XWHProgressHUD.hide()
            }
        }
    }
    
    private func getSportTotalRecord(compeltion: (() -> Void)? = nil) {
        XWHSportVM().getSportTotalRecord(type: sSportType) { [weak self] error in
            log.error(error)
            compeltion?()
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [weak self] response in
            compeltion?()
            
            guard let self = self else {
                return
            }
            guard let retModel = response.data as? XWHSportTotalRecordModel else {
                log.debug("运动 - 所有运动总结数据为空")
                return
            }
            
            self.sportTotalRecord = retModel
            self.allSummaryView.update(sTotalRecord: self.sportTotalRecord)
        }
    }
    
    private func getSportRecordList(compeltion: (() -> Void)? = nil) {
        XWHSportVM().getSports(year: sYear, type: sSportType) { [weak self] error in
            log.error(error)
            compeltion?()
            
            guard let self = self else {
                return
            }
            
            self.refreshFooter?.endRefreshing()
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.tableView.reloadData()
        } successHandler: { [weak self] response in
            compeltion?()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? [XWHSportMonthRecordModel] else {
                log.debug("运动 - 运动列表数据为空")
                self.refreshFooter?.endRefreshing()

                return
            }
            
            if self.sYear == self.bYear {
                self.sportRecords.removeAll()
            }
            
            self.sportRecords.append(contentsOf: retModel)
            
            if self.sYear - self.bYear >= 4 || self.sportRecords.isEmpty {
                self.refreshFooter?.endRefreshingWithNoMoreData()
            } else {
                self.refreshFooter?.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }
    
}


// MARK: - UI Jump
extension XWHSportRecordListTBVC {
    
    /// 运动详情
    private func gotoSportRecordDetail(recordItem: XWHSportMonthRecordItemsSubItemModel) {
        let vc = XWHSportRecordDetailVC()
        vc.sportId = recordItem.sportId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
