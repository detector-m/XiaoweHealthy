//
//  XWHUIFontExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

extension UIFont {
    
    @objc class func iconFont(size: CGFloat) -> UIFont {
        let font = UIFont(name: "iconfont", size: size)
        if font == nil {
            assert((font != nil), "UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
        }
        return font ?? UIFont.systemFont(ofSize: 18)
    }

}
