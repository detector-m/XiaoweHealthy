//
//  XWHGenderSelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHGenderSelectVC: XWHRegisterFillInfoBaseVC & UIPickerViewDelegate & UIPickerViewDataSource {
    
    lazy var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        preBtn.isHidden = true
        titleLb.text = R.string.xwhDisplayText.性别()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(pickerView)
    }
    
    override func relayoutSubViews() {
        layoutTitleSubTitle()
        
        layoutPickerView()
        
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    override func clickBtnAction(sender: UIButton) {
        if sender == preBtn {
            
        } else {
            let vc = XWHHeightSelectVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func layoutPickerView() {
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(subLb.snp.bottom).offset(28)
            make.height.equalTo(327)
        }
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
        cLabel.font = R.font.harmonyOS_Sans_Medium(size: 38)
        cLabel.textColor = UIColor(hex: 0x000000, transparency: 0.9)
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
