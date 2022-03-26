//
//  XWHAddBrandDeviceVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import UIKit

class XWHAddBrandDeviceVC: XWHDeviceBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.添加设备()
        detailLb.text = R.string.xwhDeviceText.创维智能手表()
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(94)
            make.height.equalTo(40)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.height.equalTo(20)
        }
    }

}
