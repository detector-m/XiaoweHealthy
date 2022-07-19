//
//  XWHPickWeightPopupView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickWeightPopupView: XWHPickHeightPopupView {
    
    private lazy var _contentView = XWHPickWeightPopupContentView()
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
    
    override func update(userModel: XWHUserModel) {
        _contentView.update(userModel: userModel)
    }

}


extension XWHPickWeightPopupView {
    
    class func showPickWeight(userModel: XWHUserModel, completion: @escaping (XWHUserModel) -> Void) {
        let cView = XWHPickWeightPopupView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.update(userModel: userModel)
        cView.completion = completion
        
        cView.show()
    }
    
}
