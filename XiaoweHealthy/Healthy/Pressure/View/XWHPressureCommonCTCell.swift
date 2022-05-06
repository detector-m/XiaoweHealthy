//
//  XWHPressureCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHPressureCommonCTCell: XWHHealthyCommonCTCell {
    
    func update(_ title: String, _ value: String, _ unit: String) {
        textLb.text = title
        
        let cValue = value + " "
        let cText = cValue + unit
        detailLb.attributedText = cText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)], toOccurrencesOf: cValue).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12)], toOccurrencesOf: unit)
    }
    
}
