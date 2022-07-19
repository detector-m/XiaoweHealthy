//
//  XWHPickBirthdayPopupView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickBirthdayPopupView: XWHPickHeightPopupView {

    private lazy var _contentView = XWHPickBirthdayPopupContentView()
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

extension XWHPickBirthdayPopupView {
    
    class func showPickBirthday(userModel: XWHUserModel, completion: @escaping (XWHUserModel) -> Void) {
        let cView = XWHPickBirthdayPopupView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.update(userModel: userModel)
        cView.completion = completion
        
        cView.show()
    }
    
}
