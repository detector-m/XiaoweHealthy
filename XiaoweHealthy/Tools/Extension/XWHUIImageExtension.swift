//
//  XWHUIImageExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

extension UIImage {
    
    @objc class func iconFont(text: String, size: CGFloat, color: UIColor) -> UIImage {
        let size = size
        let scale = UIScreen.main.scale
        let realSize = size * scale
        let font = UIFont.iconFont(size: realSize)
        UIGraphicsBeginImageContext(CGSize(width: realSize, height: realSize))
        let textStr = text as NSString
        if textStr.responds(to: NSSelectorFromString("drawAtPoint:withAttributes:")) {
            textStr.draw(at: CGPoint.zero, withAttributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        }
        var image: UIImage = UIImage()
        if let cgimage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
            image = UIImage(cgImage: cgimage, scale: scale, orientation: .up)
            UIGraphicsEndImageContext()
        }
        return image
    }
    
}

