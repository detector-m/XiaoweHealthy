//
//  XWHHealthyBaseCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit
import FTPopOverMenu_Swift

class XWHHealthyBaseCTVC: XWHCollectionViewBaseVC {
    
    lazy var dateSegment = XWHDateSegmentView()
    
    lazy var uiManager = XWHHealthyUIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateSegment.segmentValueChangedHandler = { [unowned self] dateSegmentType in
            self.dateSegmentValueChanged(dateSegmentType)
        }
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        let rightItem = getNavItem(text: XWHIconFontOcticons.more.rawValue, font: UIFont.iconFont(size: 22), color: fontDarkColor, image: nil, target: self, action: #selector(clickNavRightItem(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func clickNavRightItem(_ sender: UIButton) {
        let menuItems: [String] = [R.string.xwhHealthyText.心率设置(), R.string.xwhHealthyText.所有数据()]
        showPopMenu(sender, menuItems) { sIndex in
            
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(dateSegment)
    }
    
    override func relayoutSubViews() {
        relayoutDateSegment()
        relayoutCollectionView()
    }
    
    @objc final func relayoutDateSegment() {
        dateSegment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(120)
            make.height.equalTo(32)
        }
    }
    
    @objc func relayoutCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(dateSegment)
            make.top.equalTo(dateSegment.snp.bottom).offset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        
    }

}


// MARK: - PopMenu
@objc extension XWHHealthyBaseCTVC {
    
    func showPopMenu(_ sender: UIView, _ mItems: [String], _ completion: ((Int) -> Void)? = nil) {
        let iImage = UIImage(color: bgColor, size: CGSize(width: 12, height: 12))
        
        let menuImages: [UIImage] = mItems.map({ _ in iImage })
        FTPopOverMenu.showForSender(sender: sender, with: mItems, menuImageArray: menuImages, popOverPosition: .alwaysUnderSender, config: getPopMenuConfig(), done: completion, cancel: nil)
        
//        var senderRect = CGRect.zero
//        if let superView = sender.superview {
//            senderRect = superView.convert(sender.frame, to: view)
//        }
//        senderRect = CGRect(center: CGPoint(x: senderRect.center.x - 10, y: senderRect.center.y), size: senderRect.size)
//        FTPopOverMenu.showFromSenderFrame(senderFrame: senderRect, with: menuItems, menuImageArray: menuImages, popOverPosition: .alwaysUnderSender, config: getPopMenuConfig()) { sIndex in
//
//        } cancel: {
//
//        }
        
//        FTPopOverMenu.showForSender(sender: sender, with: mItems, menuImageArray: menuImages, popOverPosition: .alwaysUnderSender, config: getPopMenuConfig()) { sIndex in
//
//        } cancel: {
//
//        }
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
