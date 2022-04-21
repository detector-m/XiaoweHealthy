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

    var slectedType: XWHHealthyDateSegmentType {
        dateSegments[segment.index]
    }
    
    var segmentValueChangedHandler: ((XWHHealthyDateSegmentType) -> Void)?
    
    private(set) lazy var segment = BetterSegmentedControl()
    
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
        segmentValueChangedHandler?(slectedType)
    }

}
