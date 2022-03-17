//
//  XWHBirthdaySelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHBirthdaySelectVC: XWHRegisterFillInfoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDisplayText.出生年月()
        
        nextBtn.setTitle(R.string.xwhDisplayText.完成(), for: .normal)
    }
    
    override func relayoutSubViews() {
        layoutTitleSubTitle()
        layoutPreNextBtn()
    }

    override func clickBtnAction(sender: UIButton) {
        if sender == preBtn {
            navigationController?.popViewController()
        } else {
            dismiss(animated: true)
        }
    }

}
