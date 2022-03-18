//
//  XWHBirthdaySelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHBirthdaySelectVC: XWHGenderSelectVC {
    
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())    //日期类型

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.selectRow(90, inComponent: 0, animated: false)
    }
    

    override func addSubViews() {
        super.addSubViews()
        
        preBtn.isHidden = false
        titleLb.text = R.string.xwhDisplayText.出生年月()
        
        nextBtn.setTitle(R.string.xwhDisplayText.完成(), for: .normal)
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
            dismiss(animated: true)
        }
    }
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return currentDateCom.year! - 1900
        } else if component == 1 {
            return 12
        } else {
            let year: Int = pickerView.selectedRow(inComponent: 0) + currentDateCom.year!
            let month: Int = pickerView.selectedRow(inComponent: 1) + 1
            let days: Int = howManyDays(inThisYear: year, withMonth: month)
            return days
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.width / 3
    }
    
    override func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            return "\((currentDateCom.year!) + row)\("年")"
//        } else if component == 1 {
//            return "\(row + 1)\("月")"
//        } else {
//            return "\(row + 1)\("日")"
//        }
//    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rLabel = view as? UILabel
        lazy var cLabel = UILabel()
        if let tLabel = rLabel {
            cLabel = tLabel
        }
        cLabel.font = R.font.harmonyOS_Sans_Medium(size: 38)
        cLabel.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        cLabel.textAlignment = .center
        
        var cText = ""
        if component == 0 {
            cText = (1900 + row).string
        } else if component == 1 {
            cText = String(format: "%02d", row + 1)
        } else {
            cText = String(format: "%02d", row + 1)
        }
        cLabel.text = cText
        
        return cLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            pickerView.reloadComponent(2)
        }
    }

}

extension XWHBirthdaySelectVC {
    
   fileprivate func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
       
        return 29
    }
    
}


