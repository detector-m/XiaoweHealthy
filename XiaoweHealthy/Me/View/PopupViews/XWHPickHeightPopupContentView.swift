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
        
        cLabel.textAlignment = .center
        
        var cText = ""
        let unit = " kg"
        let attr: NSAttributedString
        
        let valueFont = XWHFont.harmonyOSSans(ofSize: 32, weight: .medium)
        let unitFont = XWHFont.harmonyOSSans(ofSize: 20, weight: .medium)

        if row == pickerView.selectedRow(inComponent: component) {
            cText = (30 + row).string
            attr = (cText + unit).colored(with: btnBgColor).applying(attributes: [.font: valueFont], toOccurrencesOf: cText).applying(attributes: [.font: unitFont], toOccurrencesOf: unit)
            
            cLabel.attributedText = attr
        } else {
            cLabel.font = valueFont
            cLabel.textColor = fontDarkColor
            
            cLabel.text = (30 + row).string
        }
        
        return cLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }

}
