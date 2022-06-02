//
//  XWHChartMarkerView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/13.
//

import UIKit
import Charts

class XWHChartMarkerView: MarkerView {
    
    lazy var contentView = UIView()
    lazy var textLb = UILabel()
    lazy var detailLb = UILabel()

    lazy var lineView = UIView()
    
    private var lineOffset: CGFloat = 0
    
    override var frame: CGRect {
        didSet {
            offset = CGPoint(x: -(frame.width / 2), y: -frame.height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        contentView.layer.cornerRadius = 12
        contentView.layer.backgroundColor = bgColor.cgColor
        addSubview(contentView)
        
        lineView.backgroundColor = bgColor
        addSubview(lineView)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        textLb.textAlignment = .left
        textLb.adjustsFontSizeToFitWidth = true
        addSubview(textLb)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textAlignment = .left
        detailLb.adjustsFontSizeToFitWidth = true
        addSubview(detailLb)
    }
    
    @objc func relayoutSubViews() {
        var xOffset = 12.cgFloat
        let contentWidth = width - xOffset * 2
        contentView.frame = CGRect(x: xOffset, y: 0, width: contentWidth, height: 67)
        
        let contentOffset: CGFloat = 16
        xOffset += contentOffset
        textLb.frame = CGRect(x: xOffset, y: 10, width: contentView.width - contentOffset * 2, height: 27)
        
        detailLb.frame = CGRect(x: textLb.x, y: textLb.frame.maxY + 2, width: textLb.width, height: 16)
        
        lineView.frame = CGRect(x: (width - 3) / 2 + lineOffset, y: contentView.frame.maxY, width: 3, height: height - contentView.frame.maxY)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        relayoutSubViews()
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        guard let chart = chartView else { return self.offset }
        
        var offset = self.offset
        
        let width = self.bounds.size.width
//        let height = self.bounds.size.height
        let minHeight: CGFloat = 68
        var tHeight = minHeight
        
        if point.x + offset.x < 0.0 {
            offset.x = -point.x
        }
        else if point.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - point.x - width
        }
    
        offset.y = -point.y
        
        tHeight = point.y
        if tHeight == minHeight {
            tHeight = minHeight
        }
        
        var tFrame = frame
        tFrame.size.height = tHeight
        frame = tFrame
        
        return offset
    }
    
    func setShowOffset(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        let offsetY: CGFloat = -(bounds.size.height)
        var offsetX: CGFloat = -(bounds.size.width / 2)
    //        if CGFloat(highlight.yPx) < markerView.height {
    //            offsetY = -CGFloat(highlight.yPx)
    //        }
        
        if CGFloat(highlight.xPx) + width / 2 > chartView.width {
            offsetX = chartView.width - (CGFloat(highlight.xPx) + width / 2) - (bounds.size.width / 2)
        } else if CGFloat(highlight.xPx) - width / 2 < 0 {
            offsetX = -CGFloat(highlight.xPx)
        }
        
        lineOffset = (-(bounds.size.width / 2) - offsetX)
        
        lineView.frame = CGRect(x: (width - 3) / 2 + lineOffset, y: contentView.frame.maxY, width: 3, height: height - contentView.frame.maxY)
        
//        setNeedsLayout()
    }

}
