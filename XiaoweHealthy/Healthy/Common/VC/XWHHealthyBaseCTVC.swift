//
//  XWHHealthyBaseCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit
import FTPopOverMenu_Swift

class XWHHealthyBaseCTVC: XWHCollectionViewBaseVC {
    
    lazy var dateBtn = UIButton()
    lazy var arrowDownImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 12, color: fontDarkColor)
    
    lazy var sDayDate = Date()
    lazy var sWeekDate = Date()
    lazy var sMonthDate = Date()
    lazy var sYearDate = Date()
    
    lazy var dateSegment = XWHDateSegmentView()
    var dateType: XWHHealthyDateSegmentType {
        dateSegment.sType
    }
//    var dateFormat: String {
//        switch dateType {
//        case .day:
//            return XWHDate.yearMonthDayFormat
//        case .week:
//            return XWHDate.yearMonthDayFormat
//
//        case .month:
//            return XWHDate.yearMonthFormat
//
//        case .year:
//            return XWHDate.yearFormat
//        }
//    }
    
    lazy var uiManager = XWHHealthyUIManager()
    lazy var isHasLastCurDataItem = true
    
    var popMenuItems: [String] {
//        [R.string.xwhHealthyText.心率设置(), R.string.xwhHealthyText.所有数据()]
        []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configEventAction()
        
        updateUI(false)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
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
        
        view.addSubview(dateSegment)
    }
    
    override func relayoutSubViews() {
        relayoutDateBtn()
        relayoutDateSegment()
        relayoutCollectionView()
    }
    
    @objc final func relayoutDateBtn() {
        dateBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(79)
            make.height.equalTo(19)
        }
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
    
    @objc func configEventAction() {
        dateBtn.addTarget(self, action: #selector(clickDateBtn), for: .touchUpInside)
        dateSegment.segmentValueChangedHandler = { [unowned self] dateSegmentType in
            self.dateSegmentValueChanged(dateSegmentType)
        }
    }
    
    @objc func clickDateBtn() {
        
    }
    
    func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        updateUI(true)
    }

}

// MARK: - UI
extension XWHHealthyBaseCTVC {
    
    @objc func updateUI(_ isReloadCollectionView: Bool) {
        var btnTitle: String
        switch dateType {
        case .day:
            btnTitle = sDayDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
            
        case .week:
            let bWeekDate = sWeekDate.weekBegin
            let eWeekDate = sWeekDate.weekEnd
            
            if bWeekDate.year == eWeekDate.year, bWeekDate.month == eWeekDate.month { // 同年同月
                btnTitle = bWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat) + R.string.xwhHealthyText.至() + eWeekDate.localizedString(withFormat: "d")
            } else if bWeekDate.year == eWeekDate.year { // 同年
                btnTitle = bWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat) + R.string.xwhHealthyText.至() + eWeekDate.localizedString(withFormat: "MMMd")
            } else {
                btnTitle = bWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat) + R.string.xwhHealthyText.至() + eWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
            }
            
        case .month:
            btnTitle = sMonthDate.localizedString(withFormat: XWHDate.yearMonthFormat)
            
        case .year:
            btnTitle = sYearDate.localizedString(withFormat: XWHDate.yearFormat)
        }
        
        dateBtn.set(image: arrowDownImage, title: btnTitle, titlePosition: .left, additionalSpacing: 3, state: .normal)
        
        if isReloadCollectionView {
            collectionView.reloadData()
        }
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
    
    func didSelectPopMenuItem(at index: Int) {
        
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

// MARK: - Calendar
extension XWHHealthyBaseCTVC {
    
    func showCalendar(_ calendarHandler: XWHCalendarHandler? = nil) {
        var cHandler: XWHCalendarHandler
        
        if let tHandler = calendarHandler {
            cHandler = tHandler
        } else {
            cHandler = { [unowned self] sDate, sDateType in
                self.handleSelectedCalendar(sDate, sDateType)
            }
        }

        XWHCalendar.show(dayDate: sDayDate, weekDate: sWeekDate, monthDate: sMonthDate, yearDate: sYearDate, dateType: dateType, calendarHandler: cHandler)
    }
    
    func handleSelectedCalendar(_ sDate: Date, _ sDateType: XWHHealthyDateSegmentType) {
        setSelectedDate(sDateType, sDate)
        if dateSegment.sType == sDateType {
            dateSegmentValueChanged(sDateType)
        } else {
            dateSegment.sType = sDateType
        }
    }
    
    
    func setSelectedDate(_ sDateType: XWHHealthyDateSegmentType, _ date: Date) {
        switch sDateType {
        case .day:
            sDayDate = date
            
        case .week:
            sWeekDate = date
            
        case .month:
            sMonthDate = date
            
        case .year:
            sYearDate = date
        }
    }
    
    func getSelectedDate() -> Date {
        getSelectedDate(dateType)
    }
    
    func getSelectedDate(_ sDateType: XWHHealthyDateSegmentType) -> Date {
        switch sDateType {
        case .day:
            return sDayDate
            
        case .week:
            return sWeekDate
            
        case .month:
            return sMonthDate
            
        case .year:
            return sYearDate
        }
    }
    
}
