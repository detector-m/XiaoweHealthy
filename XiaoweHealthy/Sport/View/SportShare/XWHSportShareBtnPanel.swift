//
//  XWHSportShareBtnPanel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/12.
//

import UIKit


enum XWHSportShareBtnType: Int {
    
    case save
    case wechat
    case timeline
    case qq
    
}

class XWHSportShareBtnPanel: XWHBaseView {
    
    private(set) var shareBtns = [UIButton]()
    private(set) var shareLbs = [UILabel]()
    
    var completion: ((XWHSportShareBtnType) -> Void)?

    override func addSubViews() {
        super.addSubViews()
        
        createBtns()
        addSubviews(shareBtns)
        addSubviews(shareLbs)
    }
    
    override func relayoutSubViews() {
        let btnSize: CGFloat = 43
        var offsetY: CGFloat = 21
        let offsetX: CGFloat = (width - 26 * 3 - btnSize * 4) / 2
        for (i, iBtn) in shareBtns.enumerated() {
            iBtn.frame = CGRect(x: offsetX + (i.cgFloat * (btnSize + 26)), y: offsetY, width: btnSize, height: btnSize)
        }
        
        offsetY += 5 + btnSize
        for (i, iLb) in shareLbs.enumerated() {
            iLb.frame = CGRect(x: offsetX + (i.cgFloat * (btnSize + 26)), y: offsetY, width: btnSize, height: 14)
        }
    }
    
    private func createBtns() {
        var btn = UIButton()
        var image = R.image.save_image_icon()?.scaled(toWidth: 43)
        btn.setImage(image, for: .normal)
        btn.tag = XWHSportShareBtnType.save.rawValue
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        shareBtns.append(btn)
        
        var titleLb = UILabel()
        titleLb.textAlignment = .center
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.text = "保存"
        shareLbs.append(titleLb)
        
        btn = UIButton()
        image = R.image.wechatIcon()?.scaled(toWidth: 43)
        btn.setImage(image, for: .normal)
        btn.tag = XWHSportShareBtnType.wechat.rawValue
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        shareBtns.append(btn)
        
        titleLb = UILabel()
        titleLb.textAlignment = .center
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.text = "微信"
        shareLbs.append(titleLb)
        
        btn = UIButton()
        image = R.image.timeline_icon()?.scaled(toWidth: 43)
        btn.setImage(image, for: .normal)
        btn.tag = XWHSportShareBtnType.timeline.rawValue
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        shareBtns.append(btn)
        
        titleLb = UILabel()
        titleLb.textAlignment = .center
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.text = "朋友圈"
        shareLbs.append(titleLb)

        btn = UIButton()
        image = R.image.qqIcon()?.scaled(toWidth: 43)
        btn.setImage(image, for: .normal)
        btn.tag = XWHSportShareBtnType.qq.rawValue
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        shareBtns.append(btn)
        
        titleLb = UILabel()
        titleLb.textAlignment = .center
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.text = "QQ"
        shareLbs.append(titleLb)
    }
    
    @objc private func clickBtn(sender: UIButton) {
        let shareType = XWHSportShareBtnType(rawValue: sender.tag) ?? .save
        completion?(shareType)
    }

}
