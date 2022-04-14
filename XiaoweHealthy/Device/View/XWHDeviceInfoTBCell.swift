//
//  XWHDeviceInfoTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import UIKit

class XWHDeviceInfoTBCell: XWHCommonBaseTBCell {
    
    lazy var devImageView = XWHDeviceFaceView()
    lazy var button = UIButton()
    
    var clickCallback: (() -> ())?

    override func addSubViews() {
        super.addSubViews()
        
        devImageView.bgImageView.contentMode = .scaleAspectFit
        devImageView.imageView.contentMode = .scaleAspectFit
        devImageView.bgImageView.image = R.image.devicePlacehodlerBg()
        devImageView.imageView.image = R.image.devicePlacehodlerCover()
        contentView.addSubview(devImageView)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        button.setTitleColor(UIColor(hex: 0x2DC84D), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor(hex: 0x2DC84D, transparency: 0.1)?.cgColor
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.setImage(R.image.loading()?.scaled(toWidth: 18), for: .normal)
        contentView.addSubview(button)
        
        iconView.isHidden = true
        subIconView.isHidden = true
        
        subTitleLb.textAlignment = .left
        subTitleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
    }

    override func relayoutSubViews() {
        devImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.width.equalTo(123)
            make.top.bottom.equalToSuperview().inset(13)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(devImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(63)
            make.height.equalTo(22)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom)
            make.height.equalTo(16)
        }
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.left.equalTo(titleLb)
            make.top.equalTo(subTitleLb.snp.bottom).offset(12)
        }
    }
    
    @objc func clickButton() {
        clickCallback?()
    }

    func update(_ deviceInfo: XWHDevWatchModel, isConnected: Bool) {
        let tColor = UIColor(hex: 0x2A2A2A)!
        let txt1 = "SKYWORTH"
//            let txt2 = "Watch S1"
        let txt2 = deviceInfo.name.replacingOccurrences(of: txt1, with: "")
        let attr = "\(txt1) \(txt2)".colored(with: tColor).applying(attributes: [.font: XWHFont.skSans(ofSize: 13, weight: .bold)], toOccurrencesOf: txt1).applying(attributes: [.font: XWHFont.skSans(ofSize: 13, weight: .regular)], toOccurrencesOf: txt2)
        titleLb.attributedText = attr
        
        if isConnected {
            subTitleLb.text = R.string.xwhDeviceText.已连接电量N().replacingOccurrences(of: "N", with: deviceInfo.battery.string)
            
            button.setImage(R.image.loading()?.scaled(toWidth: 18), for: .normal)
            button.setTitle(nil, for: .normal)
            button.contentEdgeInsets = .zero
            button.snp.remakeConstraints { make in
                make.width.height.equalTo(32)
                make.left.equalTo(titleLb)
                make.top.equalTo(subTitleLb.snp.bottom).offset(12)
            }
        } else {
            subTitleLb.text = R.string.xwhDeviceText.设备已断开点击重连()
            
            button.setImage(nil, for: .normal)
            button.setTitle(R.string.xwhDeviceText.重新连接(), for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(horizontal: 12, vertical: 0)
            
            button.snp.remakeConstraints { make in
                make.width.lessThanOrEqualTo(150)
                make.height.equalTo(32)
                make.left.equalTo(titleLb)
                make.top.equalTo(subTitleLb.snp.bottom).offset(12)
            }
        }
    }
    
}
