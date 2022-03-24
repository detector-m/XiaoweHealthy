//
//  XWHWeightSelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHWeightSelectVC: XWHHeightSelectVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        var dWeight = 60
        if userModel.gender == 0 {
            dWeight = 50
        }
        
        pickerView.selectRow(dWeight - 30, inComponent: 0, animated: false)
    }
    

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDisplayText.体重()
        unitLabel.text = R.string.xwhDisplayText.公斤()
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
            userModel.weight = sRow + 30
            
            let vc = XWHBirthdaySelectVC()
            vc.userModel = userModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 470
    }
    
//    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let rLabel = view as? UILabel
//        lazy var cLabel = UILabel()
//        if let tLabel = rLabel {
//            cLabel = tLabel
//        }
//        cLabel.font = R.font.harmonyOS_Sans_Medium(size: 38)
//        cLabel.textColor = UIColor(hex: 0x000000, transparency: 0.9)
//        cLabel.textAlignment = .center
//        cLabel.text = (30 + row).string
//        
//        return cLabel
//    }

}
