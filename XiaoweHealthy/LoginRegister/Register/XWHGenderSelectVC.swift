//
//  XWHGenderSelectVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHGenderSelectVC: XWHRegisterFillInfoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        preBtn.isHidden = true
        titleLb.text = R.string.xwhDisplayText.性别()
    }
    
    override func relayoutSubViews() {
        layoutTitleSubTitle()
        
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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

}
