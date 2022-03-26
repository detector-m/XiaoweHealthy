//
//  XWHAddDeviceEntryVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import UIKit

class XWHAddDeviceEntryVC: XWHDeviceBaseVC {

    lazy var addBtn = UIButton()
    lazy var textAddBtn = UIButton()

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
        
        textAddBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        textAddBtn.setTitleColor(UIColor(hex: 0xffffff, transparency: 0.9), for: .normal)
        textAddBtn.setTitle(R.string.xwhDeviceText.添加设备(), for: .normal)
        textAddBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        textAddBtn.layer.cornerRadius = 24
        textAddBtn.addTarget(self, action: #selector(clickTextAddBtn), for: .touchUpInside)
        view.addSubview(textAddBtn)
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
        
        textAddBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(53)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
    }
    
    // MARK: - Private
    @objc private func clickAddBtn() {
        if !XWHUser.isLogined() {
            XWHAlert.showLogin(at: self)
            
            return
        }
        
        gotoAddBrandDevice()
    }
    
    @objc private func clickTextAddBtn() {
        if !XWHUser.isLogined() {
            XWHAlert.showLogin(at: self)
            
            return
        }
        
        gotoAddBrandDevice()

    }

}

// MARK: - UI Jump
extension XWHAddDeviceEntryVC {
    
    fileprivate func gotoAddBrandDevice() {
        let vc = XWHAddBrandDeviceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
