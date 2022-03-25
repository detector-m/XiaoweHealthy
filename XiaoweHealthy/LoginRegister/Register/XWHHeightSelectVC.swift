//
//  XWHHeightSelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHHeightSelectVC: XWHGenderSelectVC {
    
    lazy var unitLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dHeight = 170
        if userModel.gender == 0 {
            dHeight = 160
        }
        pickerView.selectRow(dHeight - 30, inComponent: 0, animated: false)
    }
    

    override func addSubViews() {
        super.addSubViews()
        
        preBtn.isHidden = false
        titleLb.text = R.string.xwhDisplayText.身高()
        
        unitLabel.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .medium)
        unitLabel.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        unitLabel.text = R.string.xwhDisplayText.厘米()
        view.addSubview(unitLabel)
    }
    
    override func relayoutSubViews() {
        layoutTitleSubTitle()
        
        layoutPickerView()
        
        layoutPreNextBtn()
    }

    override func clickBtnAction(sender: UIButton) {
        if sender == preBtn {
            navigationController?.popViewController()
        } else {
            let sRow = pickerView.selectedRow(inComponent: 0)
            userModel.height = sRow + 30
            
            let vc = XWHWeightSelectVC()
            vc.userModel = userModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func layoutPickerView() {
        super.layoutPickerView()
        
        unitLabel.snp.makeConstraints { make in
            make.centerX.equalTo(pickerView).offset(56)
            make.centerY.equalTo(pickerView).offset(-14)
            make.width.equalTo(30)
            make.height.equalTo(24)
        }
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
