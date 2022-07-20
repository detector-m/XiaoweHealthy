//
//  XWHPickWeightPopupContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickWeightPopupContentView: XWHPickHeightPopupContentView {
    
    override func clickConfirmBtn() {
        let sRow = pickerView.selectedRow(inComponent: 0)
        let cWeight = sRow + 30
        if userModel.weight == cWeight {
            return
        }
        userModel.weight = cWeight
        
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
    override func update(userModel: XWHUserModel) {
        self.userModel = userModel
        
        var dWeight = 60
        if userModel.gender == 0 {
            dWeight = 50
        }
        
        if userModel.weight > 0 {
            dWeight = userModel.weight
        }
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(dWeight - 30, inComponent: 0, animated: false)
    }
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 470
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rLabel = view as? UILabel
        lazy var cLabel = UILabel()
        if let tLabel = rLabel {
            cLabel = tLabel
        }
        
        cLabel.textAlignment = .center

        var cText = ""
        let unit = " cm"
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

}
