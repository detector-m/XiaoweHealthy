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
    
    private lazy var tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
    
    var tapAction: (() -> Void)?
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(iconView)
        addSubview(signalView)
        
        iconView.image = R.image.gps_icon()
        signalView.image = R.image.signalQuality_0()
        
        addGestureRecognizer(tapGes)
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
    
    @objc private func tapGesture(sender: UITapGestureRecognizer) {
        tapAction?()
    }
    
    func update(_ level: Int) {
        if level == 0 {
            signalView.image = R.image.signalQuality_0()
        } else if level == 1 {
            signalView.image = R.image.signalQuality_1()
        } else if level == 2 {
            signalView.image = R.image.signalQuality_2()
        } else if level == 3 {
            signalView.image = R.image.signalQuality_3()
        } else {
            signalView.image = R.image.signalQuality_4()
        }
    }

}
