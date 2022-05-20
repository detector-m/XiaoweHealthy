//
//  XWHMoodDataDetailTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit


// FIXME: 需要完善
/// 详细数据界面
class XWHMoodDataDetailTBVC: XWHHealthyDataDetailBaseTBVC {
    
    lazy var dataModel = XWHMentalStressModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMoodDetail()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHMoodDataDetailTBVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailTBCell.self, for: indexPath)
        cell.bottomLine.isHidden = false
        if indexPath.row == 0 {
            cell.titleLb.text = R.string.xwhHealthyText.压力值()
            cell.subTitleLb.text = dataModel.value.string + " " +  XWHUIDisplayHandler.getMentalStressRangeString(dataModel.value)
        } else if indexPath.row == 1 {
            cell.titleLb.text = R.string.xwhHealthyText.测量时间()
            cell.subTitleLb.text = dataModel.time
        } else {
            cell.titleLb.text = R.string.xwhHealthyText.来源()
            cell.subTitleLb.text = dataModel.identifier
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
}


// MARK: - Api
extension XWHMoodDataDetailTBVC {
    
    private func getMoodDetail() {
        XWHProgressHUD.show()
        XWHHealthyVM().getMentalStressDetail(rId: detailId, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? XWHMentalStressModel else {
                log.error("情绪 - 获取详情数据错误")
                return
            }
            
            self.dataModel = retModel
            self.tableView.reloadData()
        })
    }
    
}

