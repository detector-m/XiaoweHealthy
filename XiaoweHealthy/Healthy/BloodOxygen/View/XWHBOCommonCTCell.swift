//
//  XWHBOCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHBOCommonCTCell: XWHHealthyCommonCTCell {
    
    func update(_ title: String, _ value: String) {
        var cValue = ""
        if value.isEmpty {
            cValue = "--"
        } else {
            cValue = value.replacingOccurrences(of: "-", with: "%-")
            cValue += "%"
        }
        
        textLb.text = title
        detailLb.text = cValue
    }
    
}
