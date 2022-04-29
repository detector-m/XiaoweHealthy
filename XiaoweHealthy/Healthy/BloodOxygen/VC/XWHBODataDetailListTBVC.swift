//
//  XWHBODataDetailListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHBODataDetailListTBVC: XWHHealthyDataDetailListBaseTBVC {
    
    override var titleText: String {
        let tString = sDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
        
        return tString + R.string.xwhHealthyText.数据()
    }
    
    lazy var allDataUIItems: [XWHBloodOxygenModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDayBloodOxygenHistory()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHBODataDetailListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allDataUIItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailListTBCell.self, for: indexPath)
        
        let cItem = allDataUIItems[indexPath.section]
        
        cell.titleLb.text = cItem.formatDate()?.string(withFormat: XWHDate.hourMinuteFormat)
        let text = cItem.value.string + "%"
        cell.subTitleLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: valueFont], toOccurrencesOf: text)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cItem = allDataUIItems[indexPath.section]
        gotoDataDetail(cItem)
    }

}

// MARK: - Jump UI
extension XWHBODataDetailListTBVC {
    
    private func gotoDataDetail(_ boModel: XWHBloodOxygenModel) {
        let vc = XWHBODataDetailTBVC()
        vc.detailId = boModel.srId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Api
extension XWHBODataDetailListTBVC {
    
    private func getDayBloodOxygenHistory() {
        XWHProgressHUD.show()
        XWHHealthyVM().getDayBloodOxygenHistory(date: sDate, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? [XWHBloodOxygenModel] else {
                log.error("血氧 - 获取所有数据错误")
                return
            }
            
            self.allDataUIItems = retModel
            self.tableView.reloadData()
        })
    }
    
}
