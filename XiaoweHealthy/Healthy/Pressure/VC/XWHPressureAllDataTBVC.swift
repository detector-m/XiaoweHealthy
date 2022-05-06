//
//  XWHPressureAllDataTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHPressureAllDataTBVC: XWHHealthyAllDataBaseTBVC {

    lazy var allDataUIItems: [XWHHeartUIAllDataItemModel] = [] {
        didSet {
            expandStates = allDataUIItems.map({ _ in false })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getYearPressureHistory()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHPressureAllDataTBVC {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return expandStates.count
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = allDataUIItems[section]
        let isOpen = expandStates[section]
        if isOpen {
            return item.items.count + 1
        }
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let section = indexPath.section
//        let isOpen = expandStates[section]
//        if isOpen, indexPath.row != 0 {
//            return 55
//        }
//        return 71
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = allDataUIItems[indexPath.section]

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHHealthyAllDataCommonTBCell.self, for: indexPath)
            
            cell.titleLb.text = item.month
            cell.isOpen = expandStates[indexPath.section]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailCommonTBCell.self, for: indexPath)
            
            let cItem = item.items[indexPath.row - 1]
            cell.titleLb.text = cItem.collectTime
            cell.subTitleLb.text = "日均 \(50) \(XWHHealthyHelper.getPressureRangeString(50))"
            
            cell.bottomLine.isHidden = false
            if item.items.count == indexPath.row {
                cell.bottomLine.isHidden = true
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row  == 0 {
            expandStates[indexPath.section] = !expandStates[indexPath.section]
            tableView.reloadData()
        } else {
            let item = allDataUIItems[indexPath.section]
            let cItem = item.items[indexPath.row - 1]

            gotoDataDetailList(cItem)
        }
    }
    
}

// MARK: - Jump UI
extension XWHPressureAllDataTBVC {
    
    private func gotoDataDetailList(_ item: XWHHeartUIAllDataRateRangeModel) {
        let vc = XWHPressureDataDetailListTBVC()
        vc.sDate = item.collectTime.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Api
extension XWHPressureAllDataTBVC {
    
    private func getYearPressureHistory() {
        XWHProgressHUD.show()
        XWHHealthyVM().getYearHeartHistory(date: Date(), failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? [XWHHeartUIAllDataItemModel] else {
                log.error("心率 - 获取所有数据错误")
                return
            }
            
            self.allDataUIItems = retModel
            self.tableView.reloadData()
        })
    }
    
}

