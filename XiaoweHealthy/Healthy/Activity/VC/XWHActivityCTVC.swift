//
//  XWHActivityCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/14.
//

import UIKit
import FTPopOverMenu_Swift


/// 每日活动控制器
class XWHActivityCTVC: XWHCollectionViewBaseVC {
    
    lazy var titleBtn = UIButton()
    lazy var dateBtn = UIButton()
    lazy var arrowDownImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 12, color: fontDarkColor)
    
    lazy var sDayDate = Date()
    
    var popMenuItems: [String] {
        [R.string.xwhHealthyText.设置目标(), R.string.xwhHealthyText.了解活动数据()]
    }
    
    var atSumUIModel: XWHActivitySumUIModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleBtn.titleForNormal = R.string.xwhHealthyText.每日活动()
        updateUI()
        
        getActivitySum()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        titleBtn.frame = CGRect(x: 0, y: 0, width: 160, height: 44)
        titleBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .medium)
        titleBtn.setTitleColor(fontDarkColor, for: .normal)
        titleBtn.addTarget(self, action: #selector(clickDateBtn), for: .touchUpInside)
        
        navigationItem.titleView = titleBtn
        
        let rightItem = getNavItem(text: XWHIconFontOcticons.more.rawValue, font: UIFont.iconFont(size: 22), color: fontDarkColor, image: nil, target: self, action: #selector(clickNavRightItem(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func clickNavRightItem(_ sender: UIButton) {
        showPopMenu(sender, popMenuItems) { [unowned self] sIndex in
            self.didSelectPopMenuItem(at: sIndex)
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
                
        dateBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14)
        dateBtn.setTitleColor(fontDarkColor, for: .normal)
        view.addSubview(dateBtn)
        
        view.backgroundColor = collectionBgColor
        collectionView.backgroundColor = collectionBgColor
        collectionView.alwaysBounceVertical = true
        
        var inset = collectionView.contentInset
        inset.bottom = 16
        collectionView.contentInset = inset
    }
    
    override func relayoutSubViews() {
        relayoutDateBtn()
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(dateBtn.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc final func relayoutDateBtn() {
        dateBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
//            make.top.equalToSuperview().offset(79)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)
            make.height.equalTo(19)
        }
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHHealthActivityCTCell.self)
        
        collectionView.register(cellWithClass: XWHActivityStepCTCell.self)
        collectionView.register(cellWithClass: XWHActivityCalCTCell.self)
        collectionView.register(cellWithClass: XWHActivityDistanceCTCell.self)
        
//        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHHealthyCTReusableView.self)
    }
    
    @objc func clickDateBtn() {
        
    }

}

// MARK: - UI
extension XWHActivityCTVC {
    
    private func updateUI() {
        let btnTitle = sDayDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
        dateBtn.set(image: arrowDownImage, title: btnTitle, titlePosition: .left, additionalSpacing: 3, state: .normal)
        
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
@objc extension XWHActivityCTVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       4
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.width, height: 205)
        }
        
        return CGSize(width: collectionView.width, height: 340)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let section = indexPath.section
        let row = indexPath.item
        
        if row == 0 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHealthActivityCTCell.self, for: indexPath)
            cell.layer.cornerRadius = 0
            cell.layer.backgroundColor = nil
            
            cell.update(atSumUIModel: atSumUIModel)
            
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHActivityStepCTCell.self, for: indexPath)
            
            cell.update(activityType: .step, atSumUIModel: atSumUIModel)
            
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHActivityCalCTCell.self, for: indexPath)
            
            cell.update(activityType: .cal, atSumUIModel: atSumUIModel)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: XWHActivityDistanceCTCell.self, for: indexPath)
            
            cell.update(activityType: .distance, atSumUIModel: atSumUIModel)
            
            return cell
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.width, height: 12)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
//        return reusableView
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let section = indexPath.section
//        let row = indexPath.item
    }
    
}

// MARK: - PopMenu
@objc extension XWHActivityCTVC {
    
    func showPopMenu(_ sender: UIView, _ mItems: [String], _ completion: ((Int) -> Void)? = nil) {
        if mItems.isEmpty {
            return
        }
        
        let iImage = UIImage(color: bgColor, size: CGSize(width: 12, height: 12))
        
        let iItem = mItems.max { $0.count < $1.count }
        
        let config = getPopMenuConfig()
        var maxWidth: CGFloat = 140
        if let maxItem = iItem {
            let iWidth = maxItem.widthWith(font: config.textFont) + config.menuIconSize * 2 + 4 * 3 + 4 * 2
            maxWidth = max(maxWidth, iWidth)
        }
        
        config.menuWidth = maxWidth
        
        let menuImages: [UIImage] = mItems.map({ _ in iImage })
        FTPopOverMenu.showForSender(sender: sender, with: mItems, menuImageArray: menuImages, popOverPosition: .alwaysUnderSender, config: config, done: completion, cancel: nil)
    }
    
    func didSelectPopMenuItem(at index: Int) {
        if index == 0 {
            gotoSetGoal()
        } else {
            gotoActivityIntroduction()
        }
    }
    
    func getPopMenuConfig() -> FTConfiguration {
        let configuration = FTConfiguration()
        configuration.menuRowHeight = 60
        configuration.menuWidth = 142
        configuration.textColor = fontDarkColor
        configuration.textFont = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        configuration.backgoundTintColor = bgColor
        configuration.borderColor = bgColor
        configuration.borderWidth = 0
        configuration.textAlignment = .left
        configuration.cornerRadius = 20
        configuration.menuSeparatorColor = bgColor
        
        configuration.globalShadowAdapter = { bgView in
            bgView.backgroundColor = coverBgColor
        }
        // set 'ignoreImageOriginalColor' to YES, images color will be same as textColor
        
        return configuration
    }
    
}

// MARK: - Api
extension XWHActivityCTVC {
    
    /// 获取每日数据概览
    private func getActivitySum() {
        if sDayDate.dayBegin == Date().dayBegin {
            return
        }
        
        XWHActivityVM().getActivity(date: sDayDate) { [unowned self] error in
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.atSumUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [unowned self] response in
            guard let retModel = response.data as? XWHActivitySumUIModel else {
                log.debug("活动 - 获取数据为空")
                
                self.atSumUIModel = nil
                self.collectionView.reloadData()
                                
                return
            }
            
            self.atSumUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - Jump UI
extension XWHActivityCTVC {
    
    /// 设置目标
    private func gotoSetGoal() {
        let vc = XWHActivitySetGoalTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 了解活动数据
    private func gotoActivityIntroduction() {
        let vc = XWHActivityIntroductionTXVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
