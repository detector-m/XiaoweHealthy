//
//  XWHPickGenderPopupView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickGenderPopupView: AppOverlayerPopupView {

    private lazy var _contentView = XWHPickGenderPopupContentView()
    override var contentView: UIView {
        _contentView
    }
    
    var completion: ((XWHUserModel) -> Void)?

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
        let cHeight: CGFloat = 301
        contentView.frame = CGRect(x: 12, y: (bounds.size.height - cHeight - UIApplication.shared.keyWindow!.safeAreaInsets.bottom - 27) - UIApplication.shared.statusBarFrame.height, width: cWidth, height: cHeight)
    }
    
    func update(userModel: XWHUserModel) {
        _contentView.update(userModel: userModel)
    }

}

extension XWHPickGenderPopupView {
    
    class func showPickGender(userModel: XWHUserModel, completion: @escaping (XWHUserModel) -> Void) {
        let cView = XWHPickGenderPopupView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.update(userModel: userModel)
        cView.completion = completion
        
        cView.show()
    }
    
}
