//
//  XWHSportStartVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/23.
//

import UIKit

class XWHSportStartVC: XWHBaseVC {
    
    var sportType: XWHSportType = .none
    
    var totalBtn = UIButton()
    var totalArrowBtn = UIButton()
    
    var totalLb = UILabel()
    
    var mapView = UIView()
    
    var locationBtn = UIButton()
    var goBtn = UIButton()
    var settingBtn = UIButton()
    
    var gpsSignalView = XWHGPSSignalView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.title = sportType.name
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(totalBtn)
        view.addSubview(totalArrowBtn)
        
        view.addSubview(totalLb)
        
        view.addSubview(mapView)
        
        view.addSubview(locationBtn)
        view.addSubview(goBtn)
        view.addSubview(settingBtn)
        
        view.addSubview(gpsSignalView)

        totalBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        totalBtn.setTitleColor(fontDarkColor.withAlphaComponent(0.4), for: .normal)
        let btnTitle = sportType.name + "总公里"
        totalBtn.setTitle(btnTitle, for: .normal)
        totalBtn.addTarget(self, action: #selector(clickTotalBtn), for: .touchUpInside)
        
        let tImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 12, color: fontDarkColor.withAlphaComponent(0.2))
        totalArrowBtn.setImage(tImage, for: .normal)
        totalArrowBtn.addTarget(self, action: #selector(clickTotalBtn), for: .touchUpInside)
        
        let unit = " 公里"
        let value = "100.12"
        let text = value + unit
        let valueFont = XWHFont.harmonyOSSans(ofSize: 40, weight: .bold)
        let unitFont = XWHFont.harmonyOSSans(ofSize: 13, weight: .bold)
        totalLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: valueFont], toOccurrencesOf: value).applying(attributes: [.font: unitFont], toOccurrencesOf: unit)
        
        mapView.layer.cornerRadius = 16
        mapView.layer.backgroundColor = collectionBgColor.cgColor
        
        locationBtn.setImage(R.image.gps_current(), for: .normal)
        locationBtn.layer.cornerRadius = 25
        locationBtn.adjustsImageWhenHighlighted = false
        locationBtn.layer.backgroundColor = UIColor.white.cgColor
        locationBtn.addTarget(self, action: #selector(clickTotalBtn), for: .touchUpInside)
        
        settingBtn.setImage(R.image.sport_setting(), for: .normal)
        settingBtn.layer.cornerRadius = 25
        settingBtn.layer.backgroundColor = UIColor.white.cgColor
        settingBtn.addTarget(self, action: #selector(clickSettingBtn), for: .touchUpInside)
        
        goBtn.layer.cornerRadius = 47
        goBtn.layer.backgroundColor = btnBgColor.cgColor
        goBtn.addTarget(self, action: #selector(clickGoBtn), for: .touchUpInside)
        goBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 25, weight: .black)
        goBtn.setTitleColor(UIColor.white, for: .normal)
        goBtn.setTitle("GO", for: .normal)
    }
    
    @objc private func clickTotalBtn() {
        
    }
    
    @objc private func clickLocationBtn() {
        
    }
    
    @objc private func clickSettingBtn() {
        
    }
    
    @objc private func clickGoBtn() {
        
    }
    
    override func relayoutSubViews() {
        totalBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.height.equalTo(17)
        }
        totalArrowBtn.snp.makeConstraints { make in
            make.left.equalTo(totalBtn.snp.right).offset(2)
            make.centerY.height.equalTo(totalBtn)
        }

        
        totalLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(totalBtn.snp.bottom).offset(6)
            make.height.equalTo(44)
        }
        
        mapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(totalLb.snp.bottom).offset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
        
        gpsSignalView.snp.makeConstraints { make in
            make.left.top.equalTo(mapView).inset(16)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(60)
        }
        
        goBtn.snp.makeConstraints { make in
            make.size.equalTo(94)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapView).offset(-63)
        }
        
        locationBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalTo(goBtn)
            make.right.equalTo(goBtn.snp.left).offset(-30)
        }
        
        settingBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalTo(goBtn)
            make.left.equalTo(goBtn.snp.right).offset(30)
        }
    }

}