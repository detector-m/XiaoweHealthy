//
//  XWHCalendarPreNextBtnView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarPreNextBtnView: UIView {
    
    lazy var preBtn = UIButton()
    lazy var nextBtn = UIButton()
    
    lazy var textLb = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        let preImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowLeft.rawValue, size: 17, color: fontDarkColor)
        let preDisableImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowLeft.rawValue, size: 17, color: fontLightColor)
        preBtn.setImage(preImage, for: .normal)
        preBtn.setImage(preDisableImage, for: .disabled)
        addSubview(preBtn)
        
        let nextImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 17, color: fontDarkColor)
        let nextDisableImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 17, color: fontLightColor)
        nextBtn.setImage(nextImage, for: .normal)
        nextBtn.setImage(nextDisableImage, for: .disabled)
        addSubview(nextBtn)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 18, weight: .medium)
        textLb.textAlignment = .center
        
        textLb.text = Date().localizedString(withFormat: XWHDate.yearMonthFormat)
        
        addSubview(textLb)
        
        nextBtn.addTarget(self, action: #selector(clickPreNextAction(_:)), for: .touchUpInside)
        preBtn.addTarget(self, action: #selector(clickPreNextAction(_:)), for: .touchUpInside)
    }
    
    @objc func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        
        preBtn.snp.makeConstraints { make in
            make.centerY.equalTo(textLb)
            make.size.equalTo(17)
            make.left.greaterThanOrEqualToSuperview()
            make.right.equalTo(textLb.snp.left).offset(-11)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerY.size.equalTo(preBtn)
            make.left.equalTo(textLb.snp.right).offset(11)
            make.right.lessThanOrEqualToSuperview()
        }
    }

}

// MARK: - Action
extension XWHCalendarPreNextBtnView {
    
    @objc private func clickPreNextAction(_ sender: UIButton) {
        
    }
    
}

