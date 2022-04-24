//
//  XWHHeartDataDetailListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHHeartDataDetailListTBVC: XWHHealthyDataDetailListBaseTBVC {

    override var titleText: String {
        return "2022年4月24日数据"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHHeartDataDetailListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailListTBCell.self, for: indexPath)
        cell.titleLb.text = "14:26"
        let value = "98"
        let unit = R.string.xwhDeviceText.次分钟()
        let text = value + unit
        cell.subTitleLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: valueFont], toOccurrencesOf: value).applying(attributes: [.font: normalFont], toOccurrencesOf: unit)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoDataDetail()
    }

}

// MARK: - Jump UI
extension XWHHeartDataDetailListTBVC {
    
    private func gotoDataDetail() {
        let vc = XWHHeartDataDetailTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
