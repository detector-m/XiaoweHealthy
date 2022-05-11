//
//  XWHColorExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//


#if canImport(UIKit)
import UIKit

public extension UIColor {

    /// SwifterSwift: Hexadecimal value string (read-only).
    var alphaHexString: String {
        let components: [Int] = {
            let comps = cgColor.components!
            let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X%02X", components[0], components[1], components[2], components[3])
    }

}

#endif
