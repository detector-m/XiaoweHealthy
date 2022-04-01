//
//  XWHDevSetUpdateVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import UIKit

class XWHDevSetUpdateVC: XWHDevSetBaseVC {
    
    lazy var headerView = XWHDevSetUpdateHeaderView()
    
    lazy var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
    
        view.addSubview(headerView)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.layer.backgroundColor = btnBgColor.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        view.addSubview(button)

        titleLb.text = R.string.xwhDeviceText.检查更新()
        
        button.setTitle(R.string.xwhDeviceText.下载升级包N(), for: .normal)
    }
    
    override func relayoutSubViews() {
        relayoutTitleLb()
        headerView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(40)
            make.height.equalTo((80 + 6 + 48))
            make.left.right.equalToSuperview().inset(28)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    @objc func clickButton() {
        
    }

}
