//
//  XWHDateSegmentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit
import BetterSegmentedControl


/// 日期分段控件
class XWHDateSegmentView: XWHBaseView {

    /// 选中的类型 (分段类型)
    var sType: XWHHealthyDateSegmentType {
        get {
            dateSegments[segment.index]
        }
        set {
            setSegmentType(newValue, animated: true, shouldSendValueChangedEvent: true)
        }
    }
    
    var segmentValueChangedHandler: ((XWHHealthyDateSegmentType) -> Void)?
    
    private lazy var segment = BetterSegmentedControl()
    
    private lazy var dateSegments: [XWHHealthyDateSegmentType] = [.day, .week, .month, .year]
    private var titles: [String] {
        dateSegments.map({ $0.name })
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(segment)
        
        config()
    }
    
    override func relayoutSubViews() {
        segment.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func config() {
        segment.layer.cornerRadius = 16
        
        let cFont = XWHFont.harmonyOSSans(ofSize: 14)
        segment.segments = LabelSegment.segments(withTitles: titles, normalBackgroundColor: nil, normalFont: cFont, normalTextColor: fontLightColor, selectedBackgroundColor: healthBarHighlightColor, selectedFont: cFont, selectedTextColor: fontDarkColor)
        segment.setOptions([.backgroundColor(healthBarBgColor), .indicatorViewBackgroundColor(healthBarHighlightColor)])
        
        segment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
    }
    
    
    @objc private func segmentValueChanged(_ sender: BetterSegmentedControl) {
        segmentValueChangedHandler?(sType)
    }
    
    func setSegmentType(_ sType: XWHHealthyDateSegmentType, animated: Bool = true, shouldSendValueChangedEvent: Bool = false) {
        segment.setIndex(dateSegments.firstIndex(of: sType) ?? 0, animated: animated, shouldSendValueChangedEvent: true)
    }

}
