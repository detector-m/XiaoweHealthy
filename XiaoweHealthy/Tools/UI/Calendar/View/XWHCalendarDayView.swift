//
//  XWHCalendarDayView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarDayView: UIView {
    
    lazy var preNextView = XWHCalendarPreNextBtnView()
    lazy var weekIndicatiorView = XWHCalendarWeekIndicatorView(config: .init())

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        addSubview(preNextView)
        addSubview(weekIndicatiorView)
    }
    
    @objc func relayoutSubViews() {
        preNextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(25)
        }
        weekIndicatiorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(24)
            make.top.equalTo(preNextView.snp.bottom).offset(22)
        }
    }

}
