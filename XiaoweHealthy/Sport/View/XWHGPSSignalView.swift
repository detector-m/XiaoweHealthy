//
//  XWHGPSSignalView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/23.
//

import UIKit

class XWHGPSSignalView: XWHBaseView {

    lazy var iconView = UIImageView()
    lazy var signalView = UIImageView()
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(iconView)
        addSubview(signalView)
        
        iconView.image = R.image.gps_icon()
        signalView.image = R.image.signalQuality_0()
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.left.centerY.equalToSuperview()
        }
        signalView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(4)
        }
    }

}
