//
//  XWHPressureDataDetailListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHPressureDataDetailListTBVC: XWHHealthyDataDetailListBaseTBVC {

    override var titleText: String {
        let tString = sDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)

        return tString + R.string.xwhHealthyText.数据()
    }
    
    lazy var allDataUIItems: [XWHHeartModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDayPressureHistory()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHPressureDataDetailListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allDataUIItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailListTBCell.self, for: indexPath)
        
        let cItem = allDataUIItems[indexPath.section]
        
        cell.titleLb.text = cItem.formatDate()?.string(withFormat: XWHDate.hourMinuteFormat)
        
        let value = cItem.value.string
        let unit = XWHHealthyHelper.getPressureRangeString(cItem.value)
        let text = value + unit
        cell.subTitleLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: valueFont], toOccurrencesOf: value).applying(attributes: [.font: normalFont], toOccurrencesOf: unit)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cItem = allDataUIItems[indexPath.section]
        gotoDataDetail(cItem)
    }

}

// MARK: - Jump UI
extension XWHPressureDataDetailListTBVC {
    
    private func gotoDataDetail(_ heartModel: XWHHeartModel) {
        let vc = XWHPressureDataDetailTBVC()
        vc.detailId = heartModel.srId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Api
extension XWHPressureDataDetailListTBVC {
    
    private func getDayPressureHistory() {
        XWHProgressHUD.show()
        XWHHealthyVM().getDayHeartHistory(date: sDate, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let retModel = response.data as? [XWHHeartModel] else {
                log.error("心率 - 获取所有数据错误")
                return
            }
            
            self.allDataUIItems = retModel
            self.tableView.reloadData()
        })
    }
    
}
