//
//  XWHPickBirthdayPopupContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import UIKit

class XWHPickBirthdayPopupContentView: XWHPickGenderPopupContentView {

    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())    //日期类型
    
    override func relayoutSubViews() {
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(274)
        }
        relayoutCancelConfirmButton()
    }
    
    override func clickConfirmBtn() {
        let yRow = pickerView.selectedRow(inComponent: 0) + 1900
        let mRow = pickerView.selectedRow(inComponent: 1) + 1
        let dRow = pickerView.selectedRow(inComponent: 2) + 1
        
        let birthday = String(format: "%d-%02d-%02d", yRow, mRow, dRow)
        if userModel.birthday == birthday {
            return
        }
        
        userModel.birthday = birthday
        
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
    override func update(userModel: XWHUserModel) {
        self.userModel = userModel
        
        let date = userModel.birthday.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()
        let yRow = date.year - 1900
        let mRow = date.month - 1
        let dRow = date.day - 1
        
        pickerView.reloadAllComponents()
        
        pickerView.selectRow(yRow, inComponent: 0, animated: false)
        pickerView.selectRow(mRow, inComponent: 1, animated: false)
        pickerView.selectRow(dRow, inComponent: 2, animated: false)
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
        if component == 0 {
            return pickerView.width * 0.4
        }
        return pickerView.width * 0.3
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
        
        cLabel.textAlignment = .center
        
        var cText = ""
        var unit = ""
        let attr: NSAttributedString
        
        let valueFont = XWHFont.harmonyOSSans(ofSize: 32, weight: .medium)
        let unitFont = XWHFont.harmonyOSSans(ofSize: 20, weight: .medium)
//        var isSelectedRow = false
        if row == pickerView.selectedRow(inComponent: component) {
            if component == 0 {
                cText = (1900 + row).string
                unit = " 年"
            } else if component == 1 {
                cText = String(format: "%02d", row + 1)
                unit = " 月"
            } else {
                cText = String(format: "%02d", row + 1)
                unit = " 日"
            }
            
            attr = (cText + unit).colored(with: btnBgColor).applying(attributes: [.font: valueFont], toOccurrencesOf: cText).applying(attributes: [.font: unitFont], toOccurrencesOf: unit)
            
            cLabel.attributedText = attr
        } else {
            cLabel.font = valueFont
            cLabel.textColor = fontDarkColor
            
            if component == 0 {
                cText = (1900 + row).string
            } else if component == 1 {
                cText = String(format: "%02d", row + 1)
            } else {
                cText = String(format: "%02d", row + 1)
            }
            cLabel.text = cText
        }
        
        return cLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 1 {
//            pickerView.reloadComponent(2)
//        }
        
        pickerView.reloadAllComponents()
    }
    
}

extension XWHPickBirthdayPopupContentView {
    
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
