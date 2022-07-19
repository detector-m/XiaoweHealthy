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
    
    var completion: ((Int) -> Void)?

    override func addSubViews() {
        super.addSubViews()
        
        _contentView.clickCallback = { [unowned self] aType in
            if aType == .cancel {
                self.hide()
                return
            }
            self.completion?(self._contentView.genderIndex)
            self.hide()
        }
    }
    
    override func relayoutSubViews() {
        overlayMaskView.frame = bounds
        
        let cWidth = bounds.width - 32
        let cHeight: CGFloat = 301
        contentView.frame = CGRect(x: 12, y: (bounds.size.height - cHeight - UIApplication.shared.keyWindow!.safeAreaInsets.bottom - 27) - UIApplication.shared.statusBarFrame.height, width: cWidth, height: cHeight)
    }
    
    func update(genderIndex: Int) {
        _contentView.update(genderIndex: genderIndex)
    }

}

extension XWHPickGenderPopupView {
    
    class func show(genderIndex: Int, completion: @escaping (Int) -> Void) {
        let cView = XWHPickGenderPopupView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.update(genderIndex: genderIndex)
        cView.completion = completion
        
        cView.show()
    }
    
}
