//
//  XWHPickHeightPopupView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickHeightPopupView: XWHPickGenderPopupView {
    
    private lazy var _contentView = XWHPickHeightPopupContentView()
    override var contentView: UIView {
        _contentView
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        _contentView.clickCallback = { [unowned self] aType in
            if aType == .cancel {
                self.hide()
                return
            }
            self.completion?(self._contentView.userModel)
            self.hide()
        }
    }

    override func relayoutSubViews() {
        overlayMaskView.frame = bounds
        
        let cWidth = bounds.width - 32
        let cHeight: CGFloat = 407
        contentView.frame = CGRect(x: 12, y: (bounds.size.height - cHeight - UIApplication.shared.keyWindow!.safeAreaInsets.bottom - 27) - UIApplication.shared.statusBarFrame.height, width: cWidth, height: cHeight)
    }
    
    override func update(userModel: XWHUserModel) {
        _contentView.update(userModel: userModel)
    }

}

extension XWHPickHeightPopupView {
    
    class func showPickHeight(userModel: XWHUserModel, completion: @escaping (XWHUserModel) -> Void) {
        let cView = XWHPickHeightPopupView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.update(userModel: userModel)
        cView.completion = completion
        
        cView.show()
    }
    
}
