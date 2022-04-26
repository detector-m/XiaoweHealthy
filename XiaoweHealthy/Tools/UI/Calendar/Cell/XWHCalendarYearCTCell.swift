//
//  XWHCalendarYearCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarYearCTCell: XWHCalendarItemCTCell {
    
    override func relayoutSubViews() {
        selectedIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(selectedIndicatorSize)
        }
        
        curIndicator.snp.makeConstraints { make in
            make.edges.equalTo(selectedIndicator).inset(2)
        }
        
        textLb.snp.makeConstraints { make in
            make.height.equalTo(30)
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
