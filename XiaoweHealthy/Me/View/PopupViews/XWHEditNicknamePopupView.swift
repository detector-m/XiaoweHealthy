//
//  XWHEditNicknamePopupView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHEditNicknamePopupView: AppOverlayerPopupView {
    
    private lazy var _contentView = XWHEditNicknameContentView()
    override var contentView: UIView {
        _contentView
    }
    
    var completion: ((String) -> Void)?

    override func addSubViews() {
        super.addSubViews()
        
        _contentView.clickCallback = { [unowned self] aType in
            if aType == .cancel {
                self.hide()
                return
            }
            self.completion?(self._contentView.nickname)
            self.hide()
        }
    }
    
    override func relayoutSubViews() {
        overlayMaskView.frame = bounds
        
        let cWidth = bounds.width - 32
        let cHeight: CGFloat = 227
        contentView.frame = CGRect(x: 12, y: (bounds.size.height - cHeight) / 2 - UIApplication.shared.statusBarFrame.height, width: cWidth, height: cHeight)
    }
    
    func update(nickname: String) {
        _contentView.update(nickname: nickname)
    }

}

extension XWHEditNicknamePopupView {
    
    class func show(nickname: String, completion: @escaping (String) -> Void) {
        let cView = XWHEditNicknamePopupView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.update(nickname: nickname)
        cView.completion = completion
        
        cView.show()
    }
    
}
