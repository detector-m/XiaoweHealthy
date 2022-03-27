//
//  XWHAddBrandDeviceCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/27.
//

import UIKit

class XWHAddBrandDeviceCTCell: XWHBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        addImageTextView()
        
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.03)?.cgColor
        
        textLb.textAlignment = .center
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(8)
            make.height.equalTo(imageView.snp.width)
        }
        
        textLb.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
}
