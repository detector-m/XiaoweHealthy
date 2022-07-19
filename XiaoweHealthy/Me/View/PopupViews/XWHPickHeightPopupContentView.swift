//
//  XWHPickHeightPopupContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickHeightPopupContentView: XWHPickGenderPopupContentView {
    
//    lazy var unitLabel = UILabel()

//    override func addSubViews() {
//        super.addSubViews()
//    }
    
    override func relayoutSubViews() {
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(274)
        }
        relayoutCancelConfirmButton()
    }
    
    override func clickConfirmBtn() {
        let sRow = pickerView.selectedRow(inComponent: 0)
        let cHeight = sRow + 30
        if userModel.height == cHeight {
            return
        }
        userModel.height = cHeight
        
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
    override func update(userModel: XWHUserModel) {
        self.userModel = userModel
        
        var dHeight = 170
        if userModel.gender == 0 {
            dHeight = 160
        }
        
        if userModel.height > 0 {
            dHeight = userModel.height
        }
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(dHeight - 30, inComponent: 0, animated: false)
    }
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 220
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rLabel = view as? UILabel
        lazy var cLabel = UILabel()
        if let tLabel = rLabel {
            cLabel = tLabel
        }
        cLabel.font = XWHFont.harmonyOSSans(ofSize: 38, weight: .medium)
        cLabel.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        cLabel.textAlignment = .center
        cLabel.text = (30 + row).string
        
        return cLabel
    }

}
