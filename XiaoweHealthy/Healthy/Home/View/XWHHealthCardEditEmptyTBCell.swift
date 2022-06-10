//
//  XWHHealthCardEditEmptyTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/10.
//

import UIKit
import SwiftRichString

class XWHHealthCardEditEmptyTBCell: XWHBaseTBCell {
    
    lazy var normal = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 12)
        $0.color = fontDarkColor.withAlphaComponent(0.35)
        $0.baselineOffset = 6
    }
    
    private var hide: String {
        return "hide"
    }
    
    private var show: String {
        return "show"
    }
    
    private lazy var groupStyle = StyleGroup(base: normal)

    override func addSubViews() {
        super.addSubViews()
        
        backgroundColor = .clear
        
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor(hex: 0x000000)!.withAlphaComponent(0.03).cgColor
        
        iconView.isHidden = true
        titleLb.textAlignment = .center
        
        groupStyle.imageProvider = { [unowned self] (imageName, attributes) in
            if imageName == self.hide {
                return R.image.cardHiddenIcon()
            }
            
            if imageName == self.show {
                return R.image.cardShowIcon()
            }
            
            return nil
        }
    }

    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    func update(isHidden: Bool) {
        var text = ""
        if isHidden {
            text = R.string.xwhHealthyText.点击ImgNamedHide将不需要的卡片隐藏()
        } else {
            text = R.string.xwhHealthyText.点击ImgNamedShow将需要的卡片显示()
        }
        
        titleLb.attributedText = text.set(style: groupStyle)
    }

}
