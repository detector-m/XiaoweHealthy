//
//  XWHFont.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/25.
//

import Foundation
import UIFontComplete
import UIKit

enum XWHFont: String, FontRepresentable {
    
    // MARK: - HarmonyOS_Sans
    case harmonyOSSansRegular = "HarmonyOS_Sans_SC"
    case harmonyOSSansMedium = "HarmonyOS_Sans_SC_Medium"
    case harmonyOSSansBold = "HarmonyOS_Sans_SC_Bold"
    
    // MARK: - HarmonyOS_Sans_Condensed
//    case harmonyOSSansCondensedRegular = "HarmonyOS_Sans_Condensed_Regular"
//    case harmonyOSSansCondensedMedium = "HarmonyOS_Sans_Condensed_Medium"
//    case harmonyOSSansCondensedBlack = "HarmonyOS_Sans_Condensed_Black"
    
    // MARK: - SKSans
    case skSansRegular = "SKSans-Regular"
    case skSansBold = "SKSans-Bold"
    
    static func harmonyOSSans(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        var cFont: UIFont? = nil
        
        if weight == .regular {
            cFont = XWHFont.harmonyOSSansRegular.of(size: fontSize)
        } else if weight == .medium {
            cFont = XWHFont.harmonyOSSansMedium.of(size: fontSize)
        } else if weight == .bold {
            cFont = XWHFont.harmonyOSSansBold.of(size: fontSize)
        } else {
            cFont = XWHFont.harmonyOSSansRegular.of(size: fontSize)
        }
        
        guard let retFont = cFont else {
            return UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        
        return retFont
    }
    
//    static func harmonyOSSansCondensed(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
//        var cFont: UIFont? = nil
//
//        if weight == .regular {
//            cFont = XWHFont.harmonyOSSansCondensedRegular.of(size: fontSize)
//        } else if weight == .medium {
//            cFont = XWHFont.harmonyOSSansCondensedMedium.of(size: fontSize)
//        } else if weight == .black {
//            cFont = XWHFont.harmonyOSSansCondensedBlack.of(size: fontSize)
//        }
//
//        guard let retFont = cFont else {
//            return UIFont.systemFont(ofSize: fontSize, weight: weight)
//        }
//
//        return retFont
//    }
    
    static func skSans(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        var cFont: UIFont? = nil
        
        if weight == .regular {
            cFont = XWHFont.skSansRegular.of(size: fontSize)
        } else if weight == .bold {
            cFont = XWHFont.skSansBold.of(size: fontSize)
        } else {
            cFont = XWHFont.skSansRegular.of(size: fontSize)
        }
        
        guard let retFont = cFont else {
            return UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        
        return retFont
    }
    
}
