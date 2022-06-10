//
//  XWHHealthCardEditTBHeader.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/10.
//

import UIKit

class XWHHealthCardEditTBHeader: XWHTBHeaderFooterBaseView {
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(22)
            make.top.equalToSuperview()
        }
    }

}
