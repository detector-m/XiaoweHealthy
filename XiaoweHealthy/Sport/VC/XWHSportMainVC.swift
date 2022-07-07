//
//  XWHSportMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHSportMainVC: XWHCollectionViewBaseVC {

    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var largeTitleHeight: CGFloat {
        64
    }
    
    override var topContentInset: CGFloat {
        66
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

    private var refreshHeader: PullToRefreshHeader?
    
    lazy var sportRecords: [XWHSportMonthRecordModel] = []
    var lastSportItem: XWHSportMonthRecordItemsSubItemModel? {
        return sportRecords.first?.record.items.first
    }

    deinit {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHeaderRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else {
                return
            }
            self.collectionView.mj_header?.beginRefreshing()
        }
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)
        
        let leftItem = getNavItem(text: R.string.xwhDisplayText.运动(), font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
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
        view.backgroundColor = .clear

        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        setLargeTitleMode()
        
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        largeTitleView.backgroundColor = collectionView.backgroundColor
        
        largeTitleView.titleLb.text = R.string.xwhDisplayText.运动()
    }
    
    override func relayoutSubViews() {
        collectionView.snp.remakeConstraints { make in
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
        collectionView.register(cellWithClass: XWHSportMainSportCTCell.self)
        
        collectionView.register(cellWithClass: XWHSportRecordCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHSportCTReusableView.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withClass: UICollectionReusableView.self)
    }
    
    func addHeaderRefresh() {
        let headerContentOffset = UIApplication.shared.statusBarFrame.height

        refreshHeader = collectionView.addHeader(contentInsetTop: topContentInset + largeTitleHeight, contentOffset: headerContentOffset) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.getSportRecordList()
        }
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
@objc extension XWHSportMainVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellWidth = (collectionView.width - 12) / 2
            return CGSize(width: cellWidth, height: 128)
        }
        
        return CGSize(width: collectionView.width, height: 132)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.item
        
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHSportMainSportCTCell.self, for: indexPath)
        
            if row == 0 {
                cell.imageView.image = R.image.sport_run()
                cell.textLb.text = R.string.xwhSportText.跑步()
                let dColor = UIColor(hex: 0x76D4EA)!
                cell.detailLb.textColor = dColor
                cell.detailLb.layer.backgroundColor = dColor.withAlphaComponent(0.2).cgColor
            } else if row == 1 {
                cell.imageView.image = R.image.sport_walk()
                cell.textLb.text = R.string.xwhSportText.步行()
                let dColor = UIColor(hex: 0x8389F3)!
                cell.detailLb.textColor = dColor
                cell.detailLb.layer.backgroundColor = dColor.withAlphaComponent(0.2).cgColor
            } else if row == 2 {
                cell.imageView.image = R.image.sport_ride()
                cell.textLb.text = R.string.xwhSportText.骑行()
                let dColor = UIColor(hex: 0x6CD267)!
                cell.detailLb.textColor = dColor
                cell.detailLb.layer.backgroundColor = dColor.withAlphaComponent(0.2).cgColor
            } else {
                cell.imageView.image = R.image.sport_climb()
                cell.textLb.text = R.string.xwhSportText.爬山()
                let dColor = UIColor(hex: 0xFFB25A)!
                cell.detailLb.textColor = dColor
                cell.detailLb.layer.backgroundColor = dColor.withAlphaComponent(0.2).cgColor
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: XWHSportRecordCTCell.self, for: indexPath)
            
            cell.update(sportRecordItem: lastSportItem)
            
            return cell
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.width, height: 52)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 12)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: XWHSportCTReusableView.self, for: indexPath)
            reusableView.textLb.text = R.string.xwhSportText.所有运动()
            
            reusableView.clickAction = { [unowned self] in
                self.gotoSportRecordList()
            }
            
            return reusableView
        } else {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
            
            return reusableView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.item
        
        if section == 0 {
            gotoCheckMapPrivacy { [unowned self] isOk in
                if isOk {
                    let sportTypes: [XWHSportType] = [.run, .walk, .ride, .climb]
                    self.gotoSportStart(sType: sportTypes[row])
                }
            }
        } else if section == 1 {
            gotoSportRecordDetail()
        }
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}

// MARK: - Api
extension XWHSportMainVC {
    
    private func getSportRecordList() {
        let cDate = Date()
        XWHSportVM().getSports(year: cDate.year, type: .none) { [weak self] error in            
            log.error(error)
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.refreshHeader?.endRefreshing()
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            guard let retModel = response.data as? [XWHSportMonthRecordModel] else {
                log.debug("运动 - 运动列表数据为空")
                return
            }
            
            self.sportRecords = retModel
            self.collectionView.reloadData()
            self.refreshHeader?.endRefreshing()
        }
    }
    
}


// MARK: - UI Jump
extension XWHSportMainVC {
    
    /// 地图隐私弹出框
    private func gotoCheckMapPrivacy(completion: @escaping ((Bool) -> Void)) {
        XWHAppManager.checkPrivacy {
            //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
            MAMapView.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        } btnAction: { isOk in
            if isOk {
                MAMapView.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
            } else {
                MAMapView.updatePrivacyAgree(AMapPrivacyAgreeStatus.notAgree)
            }
            
            completion(isOk)
        }
    }
    
    /// 运动开始
    private func gotoSportStart(sType: XWHSportType) {
        let vc = XWHSportStartVC()
        vc.sportType = sType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 运动记录列表
    private func gotoSportRecordList() {
        let vc = XWHSportRecordListTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 运动记录详情
    private func gotoSportRecordDetail() {
        let vc = XWHSportRecordDetailVC()
        vc.sportId = lastSportItem?.sportId ?? -1
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
