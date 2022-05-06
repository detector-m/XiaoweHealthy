//
//  XWHMultiColorLinearCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHMultiColorLinearCTCell: XWHBaseCTCell {
    
    private(set) lazy var mcLinearView = XWHMultiColorLinearView()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(mcLinearView)
        imageView.isHidden = true
        textLb.isHidden = true
        
        mcLinearView.layer.cornerRadius = 10
        mcLinearView.layer.masksToBounds = true
    }
    
    override func relayoutSubViews() {
        mcLinearView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    @objc func update(values: [Int], colors: [UIColor]) {
        var sum = values.sum().cgFloat
        if sum == 0 {
            sum = 100
        }
        mcLinearView.colors = colors.map({ $0.cgColor })
        mcLinearView.values = values.map({ $0.cgFloat / sum })
    }
    
}
