//
//  XWHActivityCalendarVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/16.
//

import UIKit
import JTAppleCalendar

class XWHActivityCalendarVC: XWHBaseVC {
    
    lazy var titleLb = UILabel()
    lazy var dateBtn = UIButton()
    lazy var topBgView = UIView()
    
    lazy var weekIndicatiorView = XWHCalendarWeekIndicatorView(config: .init())
    
    /// 日历选择的view
    lazy var monthView = XWHActivityCalendarMonthView()
    
    lazy var sDayDate = Date()
    var clickHandler: ((Date) -> Void)?
    
    var atSums: [XWHActivitySumUIModel] {
        var _sums = [XWHActivitySumUIModel]()
        for iValue in existAtSums {
            _sums.append(contentsOf: iValue.value)
        }
        
        return _sums
    }
    
    lazy var existAtSums: [String: [XWHActivitySumUIModel]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configEvent()
        getActivitySums(bMonthDate: sDayDate)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.title = R.string.xwhHealthyText.历史数据()
    }
    
    @objc func clickDateBtn() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        topBgView.backgroundColor = collectionBgColor
        view.addSubview(topBgView)
                
        dateBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14)
        dateBtn.setTitleColor(fontDarkColor, for: .normal)
        view.addSubview(dateBtn)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)
        titleLb.textColor = fontDarkColor
        view.addSubview(titleLb)
        
        view.addSubview(weekIndicatiorView)
        view.addSubview(monthView)
        
        let btnTitle = sDayDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
        dateBtn.titleForNormal = btnTitle
        
        titleLb.text = sDayDate.localizedString(withFormat: XWHDate.yearMonthFormat)
        
        view.backgroundColor = bgColor
        weekIndicatiorView.backgroundColor = collectionBgColor
        monthView.backgroundColor = bgColor
        
        monthView.sDayDate = sDayDate
    }
    
    override func relayoutSubViews() {
        topBgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(78)
        }
        dateBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-10)
            make.height.equalTo(19)
        }
        
        weekIndicatiorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.top.equalTo(dateBtn.snp.bottom).offset(12)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(weekIndicatiorView.snp.bottom).offset(24)
            make.height.equalTo(32)
        }
        
        monthView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLb.snp.bottom).offset(7)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-34)
        }
    }
    
    func configEvent() {
        monthView.clickDateHandler = { [unowned self] cDate in
            self.sDayDate = cDate
            
            self.clickHandler?(cDate)
            self.navigationController?.popViewController(animated: true)
        }
        
        monthView.didScrollToStartDate = { [unowned self] cDate in
            self.titleLb.text = cDate.localizedString(withFormat: XWHDate.yearMonthFormat)
            
            self.getActivitySums(bMonthDate: cDate)
        }
    }

}

// MARK: - Api
extension XWHActivityCalendarVC {
    
    /// 获取每日数据概览
    private func getActivitySums(bMonthDate: Date) {
        if XWHActivityVM.existAtSums(bMonthDate: bMonthDate, curMonthAtSums: existAtSums) {
            log.debug("当前已存在该记录 \(bMonthDate.string(withFormat: XWHDate.standardYearMonthFormat))")
            
            return
        }
        XWHActivityVM().getActivitySums(date: bMonthDate) { [unowned self] error in
            log.error(error)
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.monthView.monthView.reloadData()
        } successHandler: { [unowned self] response in
            var retSums: [XWHActivitySumUIModel]
            if let retModel = response.data as? [XWHActivitySumUIModel] {
                retSums = retModel
            } else {
                log.debug("活动 - 获取数据为空")
                retSums = []
            }
            
            self.existAtSums = XWHActivityVM.handleExistAtSums(bMonthDate: bMonthDate, sums: retSums, curMonthAtSums: self.existAtSums)
            self.monthView.atSums = self.atSums
            self.monthView.monthView.reloadData()
        }
    }
    
}
