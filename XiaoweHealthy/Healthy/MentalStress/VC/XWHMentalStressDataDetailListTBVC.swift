//
//  XWHMentalStressDataDetailListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHMentalStressDataDetailListTBVC: XWHHealthyDataDetailListBaseTBVC {

    override var titleText: String {
        let tString = sDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)

        return tString + R.string.xwhHealthyText.数据()
    }
    
    lazy var allDataUIItems: [XWHMentalStressModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDayMentalStressHistory()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHMentalStressDataDetailListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allDataUIItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailListTBCell.self, for: indexPath)
        
        let cItem = allDataUIItems[indexPath.section]
        
        cell.titleLb.text = cItem.formatDate()?.string(withFormat: XWHDate.hourMinuteFormat)
        
        let value = cItem.value.string
        let unit = XWHUIDisplayHandler.getMentalStressRangeString(cItem.value)
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
extension XWHMentalStressDataDetailListTBVC {
    
    private func gotoDataDetail(_ stressModel: XWHMentalStressModel) {
        let vc = XWHMentalStressDataDetailTBVC()
        vc.detailId = stressModel.srId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Api
extension XWHMentalStressDataDetailListTBVC {
    
    private func getDayMentalStressHistory() {
        XWHProgressHUD.show()
        XWHHealthyVM().getDayMentalStressHistory(date: sDate, failureHandler: { error in
            XWHProgressHUD.hide()
            log.error(error)
        }, successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? [XWHMentalStressModel] else {
                log.error("精神压力 - 获取天的数据错误")
                return
            }
            
            self.allDataUIItems = retModel
            self.tableView.reloadData()
        })
    }
    
}
