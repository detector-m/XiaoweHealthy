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
        
        pickerView.selectRow(140, inComponent: 0, animated: false)
    }
    

    override func addSubViews() {
        super.addSubViews()
        
        preBtn.isHidden = false
        titleLb.text = R.string.xwhDisplayText.身高()
        
        unitLabel.font = R.font.harmonyOS_Sans_Medium(size: 12)
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
            let vc = XWHWeightSelectVC()
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
        cLabel.font = R.font.harmonyOS_Sans_Medium(size: 38)
        cLabel.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        cLabel.textAlignment = .center
        cLabel.text = (30 + row).string
        
        return cLabel
    }

}
