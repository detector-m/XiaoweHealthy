//
//  XWHComLineBaseTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHComLineBaseTBCell: XWHCommonBaseTBCell {

    lazy var topLine = UIView()
    lazy var bottomLine = UIView()

    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(topLine)
        contentView.addSubview(bottomLine)
        
        topLine.isHidden = true
        topLine.backgroundColor = tableSeparatorColor
        bottomLine.backgroundColor = tableSeparatorColor
    }
    
    func relayoutTopBottomLine() {
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-16)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-16)
        }
        
        bringLineViewToFront()
    }
    
    final func bringLineViewToFront() {
        contentView.bringSubviewToFront(topLine)
        contentView.bringSubviewToFront(bottomLine)
    }
    
}
