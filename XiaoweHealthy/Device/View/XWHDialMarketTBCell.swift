//
//  XWHDialMarketTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import UIKit

class XWHDialMarketTBCell: XWHCommonBaseTBCell {
    
    lazy var dailImageView1 = UIImageView()
    lazy var dailImageView2 = UIImageView()
    lazy var dailImageView3 = UIImageView()

    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(dailImageView1)
        contentView.addSubview(dailImageView2)
        contentView.addSubview(dailImageView3)
        
        dailImageView1.image = UIImage(named: "1.jpg")
        dailImageView2.image = UIImage(named: "2.jpg")
        dailImageView3.image = UIImage(named: "3.jpg")
        
        iconView.isHidden = true
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
        
        dailImageView1.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalToSuperview().offset(20)
        }
        
        dailImageView2.snp.makeConstraints { make in
            make.size.centerY.equalTo(dailImageView1)
            make.centerX.equalToSuperview()
        }
        
        dailImageView3.snp.makeConstraints { make in
            make.size.centerY.equalTo(dailImageView1)
            make.right.equalToSuperview().offset(-20)
        }
    }

}
