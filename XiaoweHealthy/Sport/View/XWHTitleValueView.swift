//
//  XWHTitleValueView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import UIKit

enum XWHTitleValueViewType {
    
    // 标题在上
    case titleUp
    
    // 值在上
    case valueUp
    
}

class XWHTitleValueView: UIView {

    let titleLb = UILabel()
    let valueLb = UILabel()
    
    var edgeMargin: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var titleValuePadding: CGFloat = 2
    var titleLbHeight: CGFloat = 21 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var type: XWHTitleValueViewType = .titleUp {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var textAlignment: NSTextAlignment = .left {
        didSet {
            titleLb.textAlignment = textAlignment
            valueLb.textAlignment = textAlignment
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLb.adjustsFontSizeToFitWidth = true
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 13, weight: .regular)
        titleLb.textAlignment = .center
        
        valueLb.adjustsFontSizeToFitWidth = true
        valueLb.textColor = fontDarkColor
        valueLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .bold)
        valueLb.textAlignment = .center
        
        addSubview(titleLb)
        addSubview(valueLb)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds == .zero {
            return
        }
        
        var offsetY: CGFloat = edgeMargin.top
        if type == .titleUp {
            titleLb.frame = CGRect(x: 0, y: offsetY, width: width, height: titleLbHeight)
            
            offsetY = titleLb.y + titleLb.height + titleValuePadding
            valueLb.frame = CGRect(x: titleLb.x, y: offsetY, width: titleLb.width, height: height - offsetY - edgeMargin.bottom)
        } else {
            let valueHeight = height - titleLbHeight - titleValuePadding - edgeMargin.top - edgeMargin.bottom
            valueLb.frame = CGRect(x: 0, y: offsetY, width: width, height: valueHeight)

            offsetY = valueLb.y + valueLb.height + titleValuePadding
            titleLb.frame = CGRect(x: 0, y: offsetY, width: width, height: titleLbHeight)
        }
    }
    
}
