//
//  XWHChartLegendView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit

class XWHChartLegendView: XWHBaseView {

    lazy var icon1 = UIImageView()
    lazy var lb1 = UILabel()
    
    lazy var icon2 = UIImageView()
    lazy var lb2 = UILabel()
    
    lazy var icon3 = UIImageView()
    lazy var lb3 = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        icon1.layer.cornerRadius = 4
        addSubview(icon1)
        
        let lbColor = fontDarkColor.withAlphaComponent(0.35)
        let lbFont = XWHFont.harmonyOSSans(ofSize: 10)
        
        lb1.textColor = lbColor
        lb1.font = lbFont
        lb1.textAlignment = .left
        addSubview(lb1)
        
        icon2.layer.cornerRadius = 4
        addSubview(icon2)
        
        lb2.textColor = lbColor
        lb2.font = lbFont
        lb2.textAlignment = .center
        addSubview(lb2)
        
        icon3.layer.cornerRadius = 4
        addSubview(icon3)
        
        lb3.textColor = lbColor
        lb3.font = lbFont
        lb3.textAlignment = .right
        addSubview(lb3)
    }
    
    override func relayoutSubViews() {
        icon1.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        lb1.snp.makeConstraints { make in
            make.left.equalTo(icon1.snp.right)
            make.width.lessThanOrEqualTo(80)
            make.centerY.equalTo(icon1)
            make.height.equalTo(14)
        }
        
        lb2.snp.makeConstraints { make in
            make.height.centerY.width.equalTo(lb1)
            make.centerX.equalToSuperview().offset(5)
        }
        icon2.snp.makeConstraints { make in
            make.size.centerY.equalTo(icon1)
            make.right.equalTo(lb2.snp.left)
        }
        
        lb3.snp.makeConstraints { make in
            make.height.centerY.width.equalTo(lb1)
            make.right.equalToSuperview()
        }
        icon3.snp.makeConstraints { make in
            make.size.centerY.equalTo(icon1)
            make.right.equalTo(lb3.snp.left)
        }
    }
    
    @objc func update(titles: [String], colors: [UIColor]) {
        icon1.layer.backgroundColor = colors[0].cgColor
        icon2.layer.backgroundColor = colors[1].cgColor
        icon3.layer.backgroundColor = colors[2].cgColor
        
        lb1.text = titles[0]
        lb2.text = titles[1]
        lb3.text = titles[2]
    }
    
}
