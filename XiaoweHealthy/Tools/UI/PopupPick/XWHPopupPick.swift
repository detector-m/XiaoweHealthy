//
//  XWHPopupPick.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import Foundation


class XWHPopupPick {
    
    class func show(pickItems: [String], sIndex: Int, action: ((XWHAlertContentView.ActionType, Int) -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow!
        let popupPick = XWHPopupPickView(frame: window.bounds)
        window.addSubview(popupPick)

        popupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned popupPick] cType in
            if let contentView = popupPick.contentView as? XWHPopupPickContentView {
                action?(cType, contentView.pickerView.selectedRow(inComponent: 0))
            } else {
                action?(cType, 0)
            }
        }
    }
    
}

class XWHPopupPickView: RLPopupBaseView {

    private lazy var _contentView = XWHPopupPickContentView()
    
    override var contentView: RLPopupContentBaseView {
        _contentView
    }
    
//    override func addSubViews() {
//        super.addSubViews()
//    }
    
    func show(pickItems: [String], sIndex: Int, action: ((RLPopupContentBaseView.ActionType) -> Void)? = nil) {
        clickCallback = action
        _contentView.pickItems = pickItems
        _contentView.sIndex = sIndex
        _contentView.clickCallback = { [weak self] actionType in
            self?.clickCallback?(actionType)
            
            self?.hideAnimation()
        }
        _contentView.pickerView.reloadAllComponents()
        _contentView.pickerView.selectRow(sIndex, inComponent: 0, animated: false)
        
        _contentView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(48)
            make.height.greaterThanOrEqualTo(407)
//            make.height.lessThanOrEqualTo(300)
            make.top.greaterThanOrEqualToSuperview().offset(100)
        }
        
        layoutIfNeeded()
        contentCenterY = _contentView.center.y
        
        showAnimation()
    }
    
//    func showAnimation() {
//        contentView.center.y = contentCenterY + 500
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
//            self.contentView.center.y = self.contentCenterY
//        } completion: { _ in }
//    }
//
//    func hideAnimation() {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
//            self.contentView.center.y = self.contentCenterY + 500
//        } completion: { _ in
//            self.removeFromSuperview()
//        }
//    }
    
}

class XWHPopupPickContentView: RLPopupContentBaseView, UIPickerViewDelegate & UIPickerViewDataSource {
    
    lazy var pickerView = UIPickerView()
    
    lazy var pickItems = [String]()
    lazy var sIndex: Int = 0 {
        didSet {
            pickerView.selectRow(sIndex, inComponent: 0, animated: false)
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        
        cancelBtn.setTitle(R.string.xwhDisplayText.取消(), for: .normal)
        confirmBtn.setTitle(R.string.xwhDisplayText.确定(), for: .normal)
    }
    
    override func relayoutSubViews() {
        DispatchQueue.main.async { [unowned self] in
            self.relayoutCancelConfirmButton()
            self.relayoutPickerView()
        }
    }
    
    func relayoutPickerView() {
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(28)
            make.height.equalTo(274).priority(.high)
            make.bottom.equalTo(confirmBtn.snp.top)
        }
    }

    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rLabel = view as? UILabel
        lazy var cLabel = UILabel()
        if let tLabel = rLabel {
            cLabel = tLabel
        }
        cLabel.font = XWHFont.harmonyOSSans(ofSize: 32, weight: .medium)
        cLabel.textColor = fontDarkColor
        cLabel.textAlignment = .center
        cLabel.text = pickItems[row]
        
        return cLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 54
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//    }
    
}
