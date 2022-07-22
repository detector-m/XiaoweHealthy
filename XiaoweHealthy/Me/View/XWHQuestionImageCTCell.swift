//
//  XWHQuestionImageCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit
import Kingfisher

class XWHQuestionImageCTCell: XWHButtonCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        contentView.addSubview(imageView)
        contentView.sendSubviewToBack(imageView)
        
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.03).cgColor
        
        button.setImage(R.image.remove_image_icon(), for: .normal)
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .right
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(73)
            make.center.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.right.equalToSuperview().inset(3)
        }
    }
    
    func update(imageUrl: String) {
        if imageUrl.isEmpty {
            imageView.contentMode = .center
            imageView.image = R.image.add_image_icon()
            button.isHidden = true
        } else {
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: imageUrl.url)
            button.isHidden = false
        }
    }
    
}
