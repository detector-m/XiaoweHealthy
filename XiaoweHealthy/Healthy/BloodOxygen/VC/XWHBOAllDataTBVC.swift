//
//  XWHBOAllDataTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHBOAllDataTBVC: XWHHealthyAllDataBaseTBVC {
    
    lazy var allDataUIItems: [XWHBOUIBloodOxygenAllDataItemModel] = [] {
        didSet {
            expandStates = allDataUIItems.map({ _ in false })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getYearBloodOxygenHistory()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHBOAllDataTBVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = allDataUIItems[section]
        let isOpen = expandStates[section]
        if isOpen {
            return item.items.count + 1
        }
        return 1
    }
    
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
            var cText = cItem.oxygenRange
            if !cText.isEmpty {
                cText = cText.replacingOccurrences(of: "-", with: "%-")
                cText += "%"
            }
            cell.subTitleLb.text = cText
            
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
extension XWHBOAllDataTBVC {
    
    private func gotoDataDetailList(_ item: XWHBOUIAllDataBORangeModel) {
        let vc = XWHBODataDetailListTBVC()
        vc.sDate = item.collectTime.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Api
extension XWHBOAllDataTBVC {
    
    private func getYearBloodOxygenHistory() {
        XWHProgressHUD.show()
        XWHHealthyVM().getYearBloodOxygenHistory(date: Date(), failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? [XWHBOUIBloodOxygenAllDataItemModel] else {
                log.error("血氧 - 获取所有血氧错误")
                return
            }
            
            self.allDataUIItems = retModel
            self.tableView.reloadData()
        })
    }
    
}
