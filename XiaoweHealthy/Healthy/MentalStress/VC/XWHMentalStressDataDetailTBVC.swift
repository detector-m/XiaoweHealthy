//
//  XWHMentalStressDataDetailTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHMentalStressDataDetailTBVC: XWHHealthyDataDetailBaseTBVC {

    lazy var stressModel = XWHMentalStressModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMentalStressDetail()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHMentalStressDataDetailTBVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailTBCell.self, for: indexPath)
        cell.bottomLine.isHidden = false
        if indexPath.row == 0 {
            cell.titleLb.text = R.string.xwhHealthyText.压力值()
            cell.subTitleLb.text = stressModel.value.string + " " +  XWHUIDisplayHandler.getMentalStressRangeString(stressModel.value)
        } else if indexPath.row == 1 {
            cell.titleLb.text = R.string.xwhHealthyText.测量时间()
            cell.subTitleLb.text = stressModel.time
        } else {
            cell.titleLb.text = R.string.xwhHealthyText.来源()
            cell.subTitleLb.text = stressModel.identifier
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
}


// MARK: - Api
extension XWHMentalStressDataDetailTBVC {
    
    private func getMentalStressDetail() {
        XWHProgressHUD.show()
        XWHHealthyVM().getMentalStressDetail(rId: detailId, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHMentalStressModel else {
                log.error("精神压力 - 获取详情数据错误")
                return
            }
            
            self.stressModel = retModel
            self.tableView.reloadData()
        })
    }
    
}
