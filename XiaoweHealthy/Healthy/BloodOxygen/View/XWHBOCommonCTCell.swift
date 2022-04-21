//
//  XWHBOCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHBOCommonCTCell: XWHHealthyCommonCTCell {
    
    func update(_ title: String, _ value: String) {
        textLb.text = title
        detailLb.text = value
    }
    
}
