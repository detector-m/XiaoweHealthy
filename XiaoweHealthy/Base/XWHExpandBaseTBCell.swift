//
//  XWHExpandBaseTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHExpandBaseTBCell: XWHBaseTBCell {
    
    private(set) lazy var openImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 22, color: fontLightColor)
    private(set) lazy var closeImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowUp.rawValue, size: 22, color: fontLightColor)
    
    var isOpen: Bool = false {
        didSet {
            if isOpen {
                iconView.image = closeImage
            } else {
                iconView.image = openImage
            }
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        iconView.image = openImage
    }

    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(iconView.snp.left).offset(-16)
            make.centerY.height.equalToSuperview()
        }
    }
    
}
