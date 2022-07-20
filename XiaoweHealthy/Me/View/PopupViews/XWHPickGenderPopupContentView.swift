//
//  XWHPickGenderPopupContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickGenderPopupContentView: XWHMePopupContentBaseView & UIPickerViewDelegate & UIPickerViewDataSource {

    lazy var pickerView = UIPickerView()
    
    lazy var userModel = XWHUserModel()
    
    override func addSubViews() {
        super.addSubViews()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        
        titleLb.isHidden = true
    }
    
    override func relayoutSubViews() {
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalToSuperview().offset(44)
            make.height.equalTo(162)
        }
        relayoutCancelConfirmButton()
    }
    
    override func clickConfirmBtn() {
        let sRow = pickerView.selectedRow(inComponent: 0)
        var cGenderIndex = 1
        if sRow == 0 {
            cGenderIndex = 1
        } else {
            cGenderIndex = 0
        }
        
        if userModel.gender == cGenderIndex {
            return
        }
    
        userModel.gender = cGenderIndex
        
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
    func update(userModel: XWHUserModel) {
        self.userModel = userModel
        
        if self.userModel.gender < 0 {
            self.userModel.gender = 0
        }
        
        var sRow = 0
        if self.userModel.gender == 0 {
            sRow = 1
        }
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(sRow, inComponent: 0, animated: false)
    }
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
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
        if row == 0 {
            cLabel.text = R.string.xwhDisplayText.男()
        } else {
            cLabel.text = R.string.xwhDisplayText.女()
        }
        
        return cLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }

}
