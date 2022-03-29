//
//  XWHSearchDeviceVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/28.
//

import UIKit

class XWHSearchDeviceVC: XWHDeviceBaseVC {
    
    lazy var radarView = RLRadarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.radarView.scan()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.radarView.snp.remakeConstraints { make in
//                make.size.equalTo(220)
//                make.centerX.equalToSuperview()
//                make.top.equalTo(self.detailLb.snp.bottom).offset(20)
//            }
//            self.radarView.size = CGSize(width: 220, height: 220)
//            self.radarView.setNeedsLayout()
            
            self.radarView.stop()
            UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                self.radarView.radarIndicatorView.isHidden = true
                self.radarView.snp.updateConstraints { make in
                    make.size.equalTo(180)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(self.detailLb.snp.bottom).offset(20)
                }
                self.view.layoutIfNeeded()
                self.radarView.setNeedsDisplay()
                
                DispatchQueue.main.async {
                    self.radarView.radarIndicatorView.isHidden = false
                    self.radarView.scan()
                }
            } completion: { _ in
                
            }
        }
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationItem.rightBarButtonItem = getNavItem(text: R.string.xwhDeviceText.帮助(), image: nil, target: self, action: #selector(clickNavRightBtn))
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.正在配对()
        detailLb.text = R.string.xwhDeviceText.请让设备贴近手机以便搜索到蓝牙设备()
        
        view.addSubview(radarView)
    }
    
    override func relayoutSubViews() {
        relayoutTitleAndDetailLb()
        
        radarView.snp.makeConstraints { make in
            make.size.equalTo(280)
            make.centerX.equalToSuperview()
            make.top.equalTo(detailLb.snp.bottom).offset(20)
        }
    }
    
    @objc func clickNavRightBtn() {
//        gotoHelp()
        gotoTest()
    }

}

// MARK: - UI Jump
extension XWHSearchDeviceVC {
    
    fileprivate func gotoHelp() {
        XWHDevice.gotoHelp(at: self)
    }
    
    fileprivate func gotoTest() {
        let vc = XWHBindDeviceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
