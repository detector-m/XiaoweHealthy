//
//  XWHThemeConfig.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import Foundation
import UIKit

let lightBgColor = UIColor.white
let darkBgColor = lightBgColor

var bgColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightBgColor, dark: darkBgColor)
    } else {
        return lightBgColor
    }
}

let lightCollectionBgColor = UIColor(hex: 0xF8F8F8)!
let darkCollectionBgColor = lightCollectionBgColor

var collectionBgColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightCollectionBgColor, dark: darkCollectionBgColor)
    } else {
        return lightCollectionBgColor
    }
}

let lightContentBgColor = UIColor.white
let darkContentBgColor = lightContentBgColor

var contentBgColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightContentBgColor, dark: darkContentBgColor)
    } else {
        return lightContentBgColor
    }
}

let lightFontDarkColor = UIColor(hex: 0x000000, transparency: 0.9)!
let darkFontDarkColor = lightFontDarkColor

var fontDarkColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightFontDarkColor, dark: darkFontDarkColor)
    } else {
        return lightFontDarkColor
    }
}

let lightFontLightColor = UIColor(hex: 0x000000, transparency: 0.45)!
let darkFontLightColor = lightFontLightColor

var fontLightColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightFontLightColor, dark: darkFontLightColor)
    } else {
        return lightFontLightColor
    }
}

let lightFontLightLightColor = UIColor.white
let darkFontLightLightColor = lightFontLightLightColor

var fontLightLightColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightFontLightLightColor, dark: darkFontLightLightColor)
    } else {
        return lightFontLightLightColor
    }
}

let lightTableSeparatorColor = UIColor(hex: 0x000000, transparency: 0.08)!
let darkTableSeparatorColor = lightTableSeparatorColor

var tableSeparatorColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightTableSeparatorColor, dark: darkTableSeparatorColor)
    } else {
        return lightTableSeparatorColor
    }
}

let lightBtnBgColor = UIColor(hex: 0x2DC84D)!
let darkBtnBgColor = lightBtnBgColor

var btnBgColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightBtnBgColor, dark: darkBtnBgColor)
    } else {
        return lightBtnBgColor
    }
}


// MARK: - 表盘市场（Dial）

let lightDialBarBgColor = UIColor(hex: 0x000000, transparency: 0.03)!
let darkDialBarBgColor = lightDialBarBgColor

var dialBarBgColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightDialBarBgColor, dark: darkDialBarBgColor)
    } else {
        return lightDialBarBgColor
    }
}

let lightDialBarHighlightColor = UIColor.white
let darkDialBarHighlightColor = lightDialBarHighlightColor

var dialBarHighlightColor: UIColor {
    if #available(iOS 13.0, *) {
        return UIColor(light: lightDialBarHighlightColor, dark: darkDialBarHighlightColor)
    } else {
        return lightDialBarHighlightColor
    }
}

