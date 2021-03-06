//
//  XWHDialMarketTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import UIKit
import Kingfisher

class XWHDialMarketTBCell: XWHCommonBaseTBCell {
    
    lazy var dialImageView1 = UIImageView()
    lazy var dialImageView2 = UIImageView()
    lazy var dialImageView3 = UIImageView()

    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(dialImageView1)
        contentView.addSubview(dialImageView2)
        contentView.addSubview(dialImageView3)
        
//        dialImageView1.image = UIImage(named: "1.jpg")
//        dialImageView2.image = UIImage(named: "2.jpg")
//        dialImageView3.image = UIImage(named: "3.jpg")
        
        iconView.isHidden = true
        dialImageView1.isHidden = true
        dialImageView2.isHidden = true
        dialImageView3.isHidden = true
    }
    
    override func relayoutSubViews() {
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.top.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-16)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalTo(subIconView)
            make.right.equalTo(subIconView.snp.left)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(subTitleLb.snp.left).offset(-6)
            make.centerY.equalTo(subTitleLb)
            make.height.equalTo(22)
        }
        
        dialImageView1.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalToSuperview().offset(20)
        }
        
        dialImageView2.snp.makeConstraints { make in
            make.size.centerY.equalTo(dialImageView1)
            make.centerX.equalToSuperview()
        }
        
        dialImageView3.snp.makeConstraints { make in
            make.size.centerY.equalTo(dialImageView1)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func update(title: String, subTitle: String, dials: [XWHDialModel]) {
        titleLb.text = title
        subTitleLb.text = subTitle
        
        dialImageView1.isHidden = true
        dialImageView2.isHidden = true
        dialImageView3.isHidden = true
        
        if dials.isEmpty {
            return
        }
        
        dialImageView1.isHidden = false
        dialImageView2.isHidden = false
        dialImageView3.isHidden = false
        
        if dials.count == 1 {
            dialImageView1.isHidden = false
            dialImageView1.kf.setImage(with: dials[0].image.url)
        } else if dials.count == 2 {
            dialImageView1.isHidden = false
            dialImageView2.isHidden = false
            
            dialImageView1.kf.setImage(with: dials[0].image.url)
            dialImageView2.kf.setImage(with: dials[1].image.url)
        } else {
            dialImageView1.isHidden = false
            dialImageView2.isHidden = false
            dialImageView3.isHidden = false
            
            dialImageView1.kf.setImage(with: dials[0].image.url)
            dialImageView2.kf.setImage(with: dials[1].image.url)
            dialImageView3.kf.setImage(with: dials[2].image.url)
        }
    }

}
