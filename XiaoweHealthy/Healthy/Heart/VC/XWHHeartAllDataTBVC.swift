//
//  XWHHeartAllDataTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHHeartAllDataTBVC: XWHHealthyAllDataBaseTBVC {
    
    lazy var items: [[String]] = [["2022年4月", "4月6日", "4月5日", "4月3日"], ["2022年3月", "3月6日", "3月5日", "3月3日"], ["2022年2月", "2月6日", "2月5日", "2月3日"], ["2022年1月", "1月6日", "1月5日", "1月3日"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        expandStates = items.map({ _ in false })
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHHeartAllDataTBVC {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return expandStates.count
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        let isOpen = expandStates[section]
        if isOpen {
            return item.count
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
        let item = items[indexPath.section]

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHHealthyAllDataCommonTBCell.self, for: indexPath)
            
            cell.titleLb.text = item[indexPath.row]
            cell.isOpen = expandStates[indexPath.section]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailCommonTBCell.self, for: indexPath)
            
            cell.titleLb.text = item[indexPath.row]
            cell.subTitleLb.text = "110-120次/分钟"
            
            cell.bottomLine.isHidden = false
            if item.count == (indexPath.row + 1) {
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
            gotoDataDetailList()
        }
    }
    
}

// MARK: - Jump UI
extension XWHHeartAllDataTBVC {
    
    private func gotoDataDetailList() {
        let vc = XWHHeartDataDetailListTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
