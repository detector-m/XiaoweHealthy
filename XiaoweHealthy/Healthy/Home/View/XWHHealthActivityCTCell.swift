//
//  XWHHealthActivityCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/11.
//

import UIKit

class XWHHealthActivityCTCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView()
    lazy var textLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(textLb)
        
        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 12)
    }
    
    @objc func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
}
