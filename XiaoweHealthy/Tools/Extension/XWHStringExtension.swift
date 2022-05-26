//
//  XWHStringExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/26.
//

import Foundation

extension String{
    
    /// String的宽度计算
    /// - Parameter font: 设定字体前提
    public func widthWith(font: UIFont) -> CGFloat {
        let str = self as NSString
        
        return str.size(withAttributes: [NSAttributedString.Key.font:font]).width
    }
    
    /// String的高度计算
    /// - Parameters:
    ///   - width: 设定宽度前提
    ///   - lineSpacing: 设定行高前提
    ///   - font: 设定字体前提
    public func heightWith(width: CGFloat, lineSpacing: CGFloat = 1.5, font: UIFont) -> CGFloat {
        let str = self as NSString
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = lineSpacing
        let size = str.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font:font], context: nil).size
        
        return size.height
    }
    /// String的宽度计算
    /// - Parameter font: 设定字体前提
//    public func widthHeight(_ size: CGSize, font: UIFont, attributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
//        let str = self as NSString
//        let s = str.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil).size.width
//
//        return s
//    }
    
}
