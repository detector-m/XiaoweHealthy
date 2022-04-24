//
//  XWHBODataDetailListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHBODataDetailListTBVC: XWHHealthyDataDetailListBaseTBVC {
    
    override var titleText: String {
        return "2022年4月22日数据"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHBODataDetailListTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthyDataDetailListTBCell.self, for: indexPath)
        cell.titleLb.text = "14:26"
        let text = "98%"
        cell.subTitleLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: valueFont], toOccurrencesOf: text)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoDataDetail()
    }

}

// MARK: - Jump UI
extension XWHBODataDetailListTBVC {
    
    private func gotoDataDetail() {
        let vc = XWHBODataDetailTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
