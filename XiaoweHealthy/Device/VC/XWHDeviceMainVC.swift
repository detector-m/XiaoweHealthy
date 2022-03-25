//
//  XWHDeviceMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHDeviceMainVC: XWHDeviceBaseVC {
    
    lazy var addBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
    }
    
    override func setupNavigationItems() {
//        navigationItem.rightBarButtonItem = getNavItem(text: nil, image: R.image.addDevice(), target: self, action: #selector(clickNavRightBtn))
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.添加设备()
        detailLb.text = R.string.xwhDeviceText.添加设备随时了解你的身体健康状态()
        
        addBtn.setImage(R.image.addDevice(), for: .normal)
        addBtn.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        view.addSubview(addBtn)
    }
    
    override func relayoutSubViews() {
        addBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(24)
            make.top.equalTo(74)
        }
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(28)
            make.right.equalTo(addBtn.snp.left).offset(-6)
            make.centerY.equalTo(addBtn)
            make.height.equalTo(40)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Private
    @objc private func clickAddBtn() {
        view.makeInsetToast("点击了")
    }

}
