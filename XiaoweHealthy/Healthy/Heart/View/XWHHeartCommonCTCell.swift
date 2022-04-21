//
//  XWHHeartCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHHeartCommonCTCell: XWHHealthyCommonCTCell {
    
    func update(_ title: String, _ value: String) {
        textLb.text = title
        
        let cValue = value + " "
        let unit = R.string.xwhDeviceText.次分钟()
        let cText = cValue + unit
        detailLb.attributedText = cText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)], toOccurrencesOf: cValue).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12)], toOccurrencesOf: unit)
    }
    
}
