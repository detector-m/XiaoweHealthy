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

}
