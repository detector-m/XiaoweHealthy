//
//  XWHCalendarWeekCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/27.
//

import UIKit

class XWHCalendarWeekCTCell: XWHCalendarDayCTCell {
    
    enum WeekDatePosition {
        case none
        case begin
        case midle
        case end
    }
    
    override var selectedIndicatorSize: CGFloat {
        didSet {
            nowIndicator.layer.cornerRadius = (selectedIndicatorSize - 4) / 2
            nowIndicator.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(selectedIndicatorSize - 4)
            }
        }
    }
    
    var position: WeekDatePosition = .none {
        didSet {
            handlePosition(position)
        }
    }
    
    private var sIndicatorColor: UIColor {
        UIColor(hex: 0x2DC84D, transparency: 0.1)!
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        selectedIndicator.layer.borderColor = nil
        selectedIndicator.layer.borderWidth = 0
        selectedIndicator.layer.cornerRadius = 0
        
        selectedIndicator.layer.backgroundColor = sIndicatorColor.cgColor
    }
    
    override func relayoutSubViews() {
        selectedIndicator.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(2)
        }
        
        nowIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(selectedIndicatorSize - 4)
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
    
    private func handlePosition(_ pos: WeekDatePosition) {
        selectedIndicator.layer.cornerRadius = 0
        selectedIndicator.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        selectedIndicator.isHidden = false
        switch pos {
        case .none:
            selectedIndicator.isHidden = true
            
        case .midle:
            break
            
        case .begin:
            selectedIndicator.layer.cornerRadius = 22
            selectedIndicator.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
        case .end:
            selectedIndicator.layer.cornerRadius = 22
            selectedIndicator.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
}
