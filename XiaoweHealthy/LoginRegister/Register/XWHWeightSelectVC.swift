//
//  XWHWeightSelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHWeightSelectVC: XWHRegisterFillInfoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDisplayText.体重()
    }
    
    override func relayoutSubViews() {
        layoutTitleSubTitle()
        layoutPreNextBtn()
    }

    override func clickBtnAction(sender: UIButton) {
        if sender == preBtn {
            navigationController?.popViewController()
        } else {
            let vc = XWHBirthdaySelectVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
