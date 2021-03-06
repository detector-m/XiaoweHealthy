//
//  XWHMoodAllDataTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit

// FIXME: 需要完善
/// 情绪的所有数据界面
class XWHMoodAllDataTBVC: XWHHealthyAllDataBaseTBVC {
    
    lazy var allDataUIItems: [XWHMoodUIAllDataItemModel] = [] {
        didSet {
            expandStates = allDataUIItems.map({ _ in false })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getYearMoodHistory()
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHMoodAllDataTBVC {
    
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
            cell.subTitleLb.text = R.string.xwhHealthyText.日均() + " " + XWHUIDisplayHandler.getMoodString(cItem.moodStatus)
            
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
extension XWHMoodAllDataTBVC {
    
    private func gotoDataDetailList(_ item: XWHMoodUIAllDataItemMoodModel) {
        let vc = XWHMoodDataDetailListTBVC()
        vc.sDate = item.collectTime.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Api
extension XWHMoodAllDataTBVC {
    
    private func getYearMoodHistory() {
        XWHProgressHUD.show()
        XWHHealthyVM().getYearMoodHistory(date: Date(), failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? [XWHMoodUIAllDataItemModel] else {
                log.error("情绪 - 获取年的数据错误")
                return
            }
            
            self.allDataUIItems = retModel
            self.tableView.reloadData()
        })
    }
    
}


