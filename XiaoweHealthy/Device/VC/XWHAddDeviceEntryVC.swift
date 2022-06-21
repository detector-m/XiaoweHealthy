//
//  XWHAddDeviceEntryVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import UIKit
import FSPagerView
import Kingfisher

class XWHAddDeviceEntryVC: XWHSearchBindDevBaseVC, FSPagerViewDataSource, FSPagerViewDelegate {

    lazy var addBtn = UIButton()
    
    lazy var pagerView = FSPagerView()
    lazy var pageControl = FSPageControl()
    
    lazy var dataSource = [XWHDeviceProductModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
//        setNavTransparent()
        
        getDeviceList()
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
        
//        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
//        button.setTitleColor(UIColor(hex: 0xffffff, transparency: 0.9), for: .normal)
        button.setTitle(R.string.xwhDeviceText.添加设备(), for: .normal)
//        textAddBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
//        textAddBtn.layer.cornerRadius = 24
        
        pagerView.register(XWHDevicePagerViewCell.self, forCellWithReuseIdentifier: "PagerViewCell")
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.itemSize = FSPagerView.automaticSize
        pagerView.isUserInteractionEnabled = false
        pagerView.automaticSlidingInterval = 5
        view.addSubview(pagerView)
        
        pageControl.numberOfPages = dataSource.count
        pageControl.contentHorizontalAlignment = .center
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.setFillColor(UIColor.black, for: .selected)
        pageControl.setFillColor(UIColor(hex: 0x000000, transparency: 0.1), for: .normal)
        view.addSubview(pageControl)
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
        
        pagerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(42)
//            make.top.equalTo(detailLb.snp.bottom).offset(75)
            make.centerY.equalToSuperview().offset(-20)
            make.height.equalTo(pagerView.snp.width).offset(40)
        }
        
        pageControl.snp.makeConstraints { make in
            make.left.right.equalTo(pagerView)
            make.top.equalTo(pagerView.snp.bottom).offset(10)
            make.height.equalTo(16)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(53)
            make.top.equalTo(pageControl.snp.bottom).offset(50)
            make.height.equalTo(48)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
    }
    
    // MARK: - Private
    @objc private func clickAddBtn() {
        addBrandDevice()
    }
    
    @objc override func clickButton() {
        addBrandDevice()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        if XWHUser.isLogined, let _ = XWHDataDeviceManager.getCurrentWatch() {
            gotoDeviceMainVC()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK: - FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataSource.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let productModel = dataSource[index]

        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PagerViewCell", at: index)
        cell.imageView?.kf.setImage(with: URL(string: productModel.cover))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        let tColor = UIColor(hex: 0x2A2A2A)!
        let txt1 = productModel.brand
        let txt2 = productModel.mode
        let attr = "\(txt1) \(txt2)".colored(with: tColor).applying(attributes: [.font: XWHFont.skSans(ofSize: 20, weight: .bold)], toOccurrencesOf: txt1).applying(attributes: [.font: XWHFont.skSans(ofSize: 20, weight: .regular)], toOccurrencesOf: txt2)
        cell.textLabel?.attributedText = attr
        
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }

}

// MARK: - Api
extension XWHAddDeviceEntryVC {
    
    fileprivate func addBrandDevice() {
        if !XWHUser.isLogined {
            XWHAlert.showLogin(at: self)
            
            return
        }
        
        RLBLEPermissions.shared.getState { [weak self] bleState in
            guard let self = self else {
                return
            }
            
            switch bleState {
            case .poweredOff:
                break
                
            case .poweredOn:
                self.gotoAddBrandDevice()
                
            case .unauthorized:
                XWHAlert.show(title: nil, message: R.string.xwhDeviceText.连接设备需要打开手机蓝牙要开启吗(), confirmTitle: R.string.xwhDeviceText.开启()) { aType in
                    if aType == .confirm {
                        RLBLEPermissions.openAppSettings()
                    }
                }
            }
        }
    }
    
}

// MARK: - Api
extension XWHAddDeviceEntryVC {
    
    fileprivate func getDeviceList() {
        XWHDeviceVM().list { error in

        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            if let cDevice = response.data as? [XWHDeviceProductModel] {
                var devProducts: [XWHDeviceProductModel] = []
                
                if cDevice.count > 6 {
                    devProducts.append(contentsOf: cDevice[..<6])
                } else {
                    devProducts = cDevice
                }
                self.dataSource = devProducts
                self.reloadUIData()
            }
        }
    }
    
}

// MARK: - UI
extension XWHAddDeviceEntryVC {
    
    fileprivate func reloadUIData() {
        pagerView.reloadData()
        pageControl.currentPage = 0
        pageControl.numberOfPages = dataSource.count
    }
    
}

// MARK: - UI Jump
extension XWHAddDeviceEntryVC {
    
    fileprivate func gotoAddBrandDevice() {
        let vc = XWHAddBrandDeviceVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func gotoDeviceMainVC() {
        let vc = XWHDeviceMainVC()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
