//
//  XWHPressureDataDetailTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHPressureDataDetailTBVC: XWHHealthyDataDetailBaseTBVC {

    lazy var heartModel = XWHHeartModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPressureDetail()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHPressureDataDetailTBVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailTBCell.self, for: indexPath)
        cell.bottomLine.isHidden = false
        if indexPath.row == 0 {
            cell.titleLb.text = R.string.xwhHealthyText.心率()
            cell.subTitleLb.text = heartModel.value.string + " " +  XWHUIDisplayHandler.getPressureRangeString(heartModel.value)
        } else if indexPath.row == 1 {
            cell.titleLb.text = R.string.xwhHealthyText.测量时间()
            cell.subTitleLb.text = heartModel.time
        } else {
            cell.titleLb.text = R.string.xwhHealthyText.来源()
            cell.subTitleLb.text = heartModel.identifier
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
}


// MARK: - Api
extension XWHPressureDataDetailTBVC {
    
    private func getPressureDetail() {
        XWHProgressHUD.show()
        XWHHealthyVM().getHeartDetail(rId: detailId, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHHeartModel else {
                log.error("心率 - 获取详情数据错误")
                return
            }
            
            self.heartModel = retModel
            self.tableView.reloadData()
        })
    }
    
}

