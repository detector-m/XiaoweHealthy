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
        addSubview(textLb)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textAlignment = .left
        addSubview(detailLb)
    }
    
    @objc func relayoutSubViews() {
        contentView.bounds = CGRect(x: 0, y: 0, width: 135, height: 67)
        contentView.center = CGPoint(x: center.x, y: 68 / 2)
        
        textLb.bounds = CGRect(x: 0, y: 0, width: contentView.width - 12, height: 27)
        textLb.center = CGPoint(x: center.x, y: 28 / 2 + 2)
        
        detailLb.bounds = CGRect(x: 0, y: 0, width: textLb.width, height: 16)
        detailLb.center = CGPoint(x: center.x, y: textLb.frame.maxY + 8 + 2)
        
        lineView.frame = CGRect(x: (width - 3) / 2 + lineOffset, y: contentView.frame.maxY, width: 3, height: height - contentView.frame.maxY)
        
//        contentView.snp.makeConstraints { make in
//            make.width.equalTo(135)
//            make.height.equalTo(67)
//            make.top.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
        
//        lineView.snp.makeConstraints { make in
//            make.width.equalTo(3)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(contentView.snp.bottom)
//            make.bottom.equalToSuperview()
//        }
//
//        textLb.snp.makeConstraints { make in
//            make.height.equalTo(27)
//            make.left.right.equalTo(contentView).inset(6)
//            make.top.equalTo(contentView).inset(11)
//        }
//
//        detailLb.snp.makeConstraints { make in
//            make.height.equalTo(16)
//            make.top.equalTo(textLb.snp.bottom).offset(2)
//            make.left.right.equalTo(textLb)
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        relayoutSubViews()
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
//        mOffset = CGPoint(x: offsetX, y: offsetY)
    }

}
