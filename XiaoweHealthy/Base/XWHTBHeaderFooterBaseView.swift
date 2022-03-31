//
//  XWHTBHeaderFooterBaseView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHTBHeaderFooterBaseView: UITableViewHeaderFooterView {
    
    lazy var titleLb = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubViews() {
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        titleLb.textColor = fontLightColor
        
        contentView.addSubview(titleLb)
    }
    
    func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.bottom.equalToSuperview()
        }
    }

}
