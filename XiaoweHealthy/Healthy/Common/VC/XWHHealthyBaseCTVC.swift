//
//  XWHHealthyBaseCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit
import FTPopOverMenu_Swift
import EmptyDataSet_Swift

class XWHHealthyBaseCTVC: XWHCollectionViewBaseVC {
    
    lazy var titleBtn = UIButton()
    lazy var dateBtn = UIButton()
    lazy var arrowDownImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 12, color: fontDarkColor)
    
    lazy var sDayDate = Date()
    lazy var sWeekDate = Date()
    lazy var sMonthDate = Date()
    lazy var sYearDate = Date()
    
    lazy var existDayWeekDataDateItems: [XWHHealthyExistDataDateModel] = []
    lazy var existMonthDataDateItems: [XWHHealthyExistDataDateModel] = []
    lazy var existYearDataDateItems: [XWHHealthyExistDataDateModel] = []

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
    var isHasLastCurDataItem: Bool {
        true
    }
    
    var popMenuItems: [String] {
//        [R.string.xwhHealthyText.心率设置(), R.string.xwhHealthyText.所有数据()]
        []
    }
    
    weak var calendarView: XWHCalendarView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configEventAction()
//        configEmptyView()
        
        updateUI(false)
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
//            make.top.equalToSuperview().offset(79)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)
            make.height.equalTo(19)
        }
    }
    
    @objc final func relayoutDateSegment() {
        dateSegment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
//            make.top.equalToSuperview().offset(120)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
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
    
    override func registerViews() {
        collectionView.register(cellWithClass: UICollectionViewCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHHealthyCTReusableView.self)
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHHealthyBaseCTVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return uiManager.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = uiManager.items[section]
        if item.uiCardType == .chart {
            return 1
        }
        
        if item.uiCardType == .curDatas {
            return uiManager.getCurDataItems(item, isHasLastItem: isHasLastCurDataItem).count
        }
        
        if item.uiCardType == .heartRange {
            return 5
        }
        
        if item.uiCardType == .boTip {
            return 1
        }
        
        if item.uiCardType == .mentalStressRange {
            return 5
        }
        
        if item.uiCardType == .sleepRange {
            return 5
        }
        
        if item.uiCardType == .moodRange {
            return 3
        }
        
        return 0
    }
    
    // - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = uiManager.items[indexPath.section]
        
        if item.uiCardType == .chart {
            return CGSize(width: collectionView.width, height: 340)
        }
        
        if item.uiCardType == .curDatas {
            return CGSize(width: collectionView.width, height: 71)
        }
        
        if item.uiCardType == .heartRange {
            let iWidth = ((collectionView.width - 12) / 2).int
            return CGSize(width: iWidth, height: 71)
        }
        
        if item.uiCardType == .boTip {
            return CGSize(width: collectionView.width, height: 170)
        }
        
        if item.uiCardType == .mentalStressRange {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.width, height: 30)
            }
            
            let cWidth = (collectionView.width - 12) / 2
            return CGSize(width: cWidth.int, height: 71)
        }
        
        if item.uiCardType == .sleepRange {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.width, height: 30)
            }
            
            return CGSize(width: collectionView.width, height: 71)
        }
        
        if item.uiCardType == .moodRange {
            return CGSize(width: collectionView.width, height: 71)
        }
        
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let item = uiManager.items[section]
        
        if item.uiCardType == .curDatas {
            return 12
        }
        
        if item.uiCardType == .heartRange {
            return 12
        }
        
        if item.uiCardType == .mentalStressRange {
            return 12
        }
        
        if item.uiCardType == .sleepRange {
            return 12
        }
        
        if item.uiCardType == .moodRange {
            return 12
        }
        
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let item = uiManager.items[section]

        if item.uiCardType == .heartRange {
            return 12
        }
        
        if item.uiCardType == .mentalStressRange {
            return 12
        }
        
        if item.uiCardType == .moodRange {
            return 12
        }
        
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let item = uiManager.items[section]
        if item.uiCardType == .chart {
            return .zero
        }
        
        return CGSize(width: collectionView.width, height: 46)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = uiManager.items[indexPath.section]

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: XWHHealthyCTReusableView.self, for: indexPath)
            header.textLb.text = uiManager.getItemTitle(item, dateSegmentType: dateType)
            
            header.button.isHidden = true

            header.clickAction = nil
            
            guard let btnTitle = uiManager.getItemDetailText(item) else {
                return header
            }
            
            header.button.isHidden = false
            header.setDetailButton(title: btnTitle)
            header.clickAction = { [unowned self] in
                self.didSelectSupplementaryView(at: indexPath)
            }
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    @objc func didSelectSupplementaryView(at indexPath: IndexPath) {
        
    }
    
}


// MARK: - PopMenu
@objc extension XWHHealthyBaseCTVC {
    
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
    
    func showCalendar(_ calendarHandler: XWHCalendarHandler? = nil, scrollDateHandler: XWHCalendarScrollDateHandler?) {
        var cHandler: XWHCalendarHandler
        
        if let tHandler = calendarHandler {
            cHandler = tHandler
        } else {
            cHandler = { [unowned self] sDate, sDateType in
                self.handleSelectedCalendar(sDate, sDateType)
            }
        }

        calendarView = XWHCalendar.show(dayDate: sDayDate, weekDate: sWeekDate, monthDate: sMonthDate, yearDate: sYearDate, dateType: dateType, calendarHandler: cHandler, scrollDateHandler: scrollDateHandler)
        calendarView?.existYearDataDateItems = existYearDataDateItems
        calendarView?.existMonthDataDateItems = existMonthDataDateItems
        calendarView?.existDayWeekDataDateItems = existDayWeekDataDateItems
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
    
    func getSelectedDateRangeString() -> String {
        switch dateType {
        case .day:
            return sDayDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
            
        case .week:
            let bWeekDate = sWeekDate.weekBegin
            let eWeekDate = sWeekDate.weekEnd
            
            if bWeekDate.year == eWeekDate.year, bWeekDate.month == eWeekDate.month { // 同年同月
                return bWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat) + R.string.xwhHealthyText.至() + eWeekDate.localizedString(withFormat: "d")
            } else if bWeekDate.year == eWeekDate.year { // 同年
                return bWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat) + R.string.xwhHealthyText.至() + eWeekDate.localizedString(withFormat: "MMMd")
            } else {
                return bWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat) + R.string.xwhHealthyText.至() + eWeekDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
            }
            
        case .month:
            return sMonthDate.localizedString(withFormat: XWHDate.yearMonthFormat)
            
        case .year:
            return sYearDate.localizedString(withFormat: XWHDate.yearFormat)
        }
    }
    
//    func setExistDataDateItems(_ sDateType: XWHHealthyDateSegmentType, _ items: [XWHHealthyExistDataDateModel]) {
//        switch sDateType {
//        case .day, .week:
//            existDayWeekDataDateItems = items
//            calendarView?.existDayWeekDataDateItems = existDayWeekDataDateItems
//            
//        case .month:
//            existMonthDataDateItems = items
//            calendarView?.existMonthDataDateItems = existMonthDataDateItems
//            
//        case .year:
//            existYearDataDateItems = items
//            calendarView?.existYearDataDateItems = existYearDataDateItems
//        }
//    }
    
    func existDataDateItemsContains(_ sDate: Date, sDateType: XWHHealthyDateSegmentType) -> Bool {
        switch sDateType {
        case .day, .week:
            return existDayWeekDataDateItems.contains(where: { $0.identifier == sDate.string(withFormat: "yyyy-MM") })
            
        case .month:
            return existMonthDataDateItems.contains(where: { $0.identifier == sDate.year.string })
            
        case .year:
            return existYearDataDateItems.contains(where: { $0.identifier == sDate.year.string })
        }
    }
    
    func updateExistDataDateItem(_ item: XWHHealthyExistDataDateModel) {
        let type = XWHHealthyDateSegmentType(rawValue: item.code) ?? .day
        
        switch type {
        case .day, .week:
            existDayWeekDataDateItems.removeAll(where: { item.identifier == $0.identifier })
            existDayWeekDataDateItems.append(item)
            calendarView?.existDayWeekDataDateItems = existDayWeekDataDateItems
            
        case .month:
            existMonthDataDateItems.removeAll(where: { item.identifier == $0.identifier })
            existMonthDataDateItems.append(item)
            calendarView?.existMonthDataDateItems = existMonthDataDateItems
            
        case .year:
            existYearDataDateItems.removeAll(where: { item.identifier == $0.identifier })
            existYearDataDateItems.append(item)
            calendarView?.existYearDataDateItems = existYearDataDateItems
        }
    }
    
//    func getExistDataDateItems(_ sDateType: XWHHealthyDateSegmentType) -> [XWHHealthyExistDataDateModel] {
//        switch sDateType {
//        case .day, .week:
//            
//            
//        case .month:
//            
//        case .year:
//        }
//    }
    
}

// MARK: - EmptySet
@objc extension XWHHealthyBaseCTVC {
    
    func configEmptyView() {
        collectionView.emptyDataSetView { [weak self] emptyView in
            guard let _ = self else {
                return
            }
            
            let text = R.string.xwhHealthyText.暂无数据()
            emptyView.titleLabelString(text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)], toOccurrencesOf: text))
        }
    }
    
}

// MARK: - Methods
extension XWHHealthyBaseCTVC {
    
    /// 是否是最后一个
    func isLast(_ item: XWHHealthyDataBaseModel?) -> Bool {
        guard let lModel = item, let lDate = lModel.formatDate() else {
            return false
        }
        
        switch dateType {
        case .day:
            return lDate.isInToday
            
        case .week:
            let nowWeekBegin = Date().weekBegin
            return nowWeekBegin == lDate.weekBegin
            
        case .month:
            return lDate.isInCurrentMonth
            
        case .year:
            return lDate.isInCurrentYear
        }
    }
    
}
