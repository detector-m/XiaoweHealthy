//
//  XWHBODataDetailTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHBODataDetailTBVC: XWHHealthyDataDetailBaseTBVC {
    
    lazy var boModel = XWHBloodOxygenModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBloodOxygenDetail()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHBODataDetailTBVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailTBCell.self, for: indexPath)

        cell.bottomLine.isHidden = false
        if indexPath.row == 0 {
            cell.titleLb.text = R.string.xwhHealthyText.血氧饱和度()
            cell.subTitleLb.text = "\(boModel.value)%"
        } else if indexPath.row == 1 {
            cell.titleLb.text = R.string.xwhHealthyText.测量时间()
            cell.subTitleLb.text = boModel.time
        } else {
            cell.titleLb.text = R.string.xwhHealthyText.来源()
            cell.subTitleLb.text = boModel.identifier
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
}

// MARK: - Api
extension XWHBODataDetailTBVC {
    
    private func getBloodOxygenDetail() {
        XWHProgressHUD.show()
        XWHHealthyVM().getBloodOxygenDetail(rId: detailId, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHBloodOxygenModel else {
                log.error("血氧 - 获取详情数据错误")
                return
            }
            
            self.boModel = retModel
            self.tableView.reloadData()
        })
    }
    
}

