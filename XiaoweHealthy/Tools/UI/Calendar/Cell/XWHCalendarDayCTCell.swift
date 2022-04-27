//
//  XWHCalendarDayCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit
import JTAppleCalendar

class XWHCalendarDayCTCell: JTACDayCell {
    
    lazy var textLb = UILabel()
    
    lazy var selectedIndicator = UIView()
    lazy var dotIndicator = UIView()
    
    lazy var nowIndicator = UIView()
    
    var selectedIndicatorSize: CGFloat = 40 {
        didSet {
            selectedIndicator.layer.cornerRadius = selectedIndicatorSize / 2
            nowIndicator.layer.cornerRadius = (selectedIndicatorSize - 4) / 2
            selectedIndicator.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(selectedIndicatorSize)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addSubViews() {
        nowIndicator.layer.backgroundColor = btnBgColor.withAlphaComponent(0.12).cgColor
        nowIndicator.layer.cornerRadius = (selectedIndicatorSize - 4) / 2
        contentView.addSubview(nowIndicator)
        
        selectedIndicator.layer.borderColor = fontDarkColor.cgColor
        selectedIndicator.layer.borderWidth = 2
        selectedIndicator.layer.cornerRadius = selectedIndicatorSize / 2
        contentView.addSubview(selectedIndicator)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 17)
        textLb.textAlignment = .center
        contentView.addSubview(textLb)
        
        dotIndicator.layer.backgroundColor = fontDarkColor.cgColor
        dotIndicator.layer.cornerRadius = 2
        contentView.addSubview(dotIndicator)
    }
    
    @objc func relayoutSubViews() {
        selectedIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(selectedIndicatorSize)
        }
        
        nowIndicator.snp.makeConstraints { make in
            make.edges.equalTo(selectedIndicator).inset(2)
        }
        
        textLb.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        
        dotIndicator.snp.makeConstraints { make in
            make.size.equalTo(4)
            make.centerX.equalToSuperview()
            make.top.equalTo(textLb.snp.bottom)
        }
    }
    
}
