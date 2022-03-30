//
//  XWHBaseTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

class XWHBaseTBCell: UITableViewCell {
    
    lazy var iconView = UIImageView()
    lazy var titleLb = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    func addSubViews() {
        contentView.addSubview(iconView)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        contentView.addSubview(titleLb)
    }
    
    func relayoutSubViews() {
        
    }
    

}
