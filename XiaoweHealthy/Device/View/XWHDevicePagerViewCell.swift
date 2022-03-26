//
//  XWHDevicePagerViewCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import UIKit
import FSPagerView

class XWHDevicePagerViewCell: FSPagerViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.shadowColor = nil
        contentView.layer.shadowRadius = 0
        contentView.layer.shadowOpacity = 0
        
        textLabel?.superview?.backgroundColor = UIColor.clear
        textLabel?.textAlignment = .center
//        textLabel?.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let contentBounds = contentView.bounds
        let textHeight: CGFloat = 40
        if let textLabel = textLabel {
            textLabel.superview!.frame = {
                var rect = contentBounds
                rect.size.height = textHeight
                rect.origin.y = contentBounds.height - textHeight
                return rect
            }()
            
            textLabel.frame = textLabel.superview!.bounds
        }
        
        if let imageView = imageView {
            var rect = contentBounds
            rect.size.height = contentBounds.height - textHeight
            imageView.frame = rect
        }
    }
    
}
