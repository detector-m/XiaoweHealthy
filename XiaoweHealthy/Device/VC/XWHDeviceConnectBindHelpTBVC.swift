//
//  XWHDeviceConnectBindHelpTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/24.
//

import UIKit


/// 连接绑定帮助
class XWHDeviceConnectBindHelpTBVC: XWHTableViewBaseVC {
    
    lazy var expandStates: [Bool] = []
    lazy var questions: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configQuestions()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        setLargeTitleMode()

        view.backgroundColor = bgColor
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        largeTitleView.backgroundColor = tableView.backgroundColor
        
        largeTitleView.titleLb.text = R.string.xwhDeviceText.查看帮助().replacingOccurrences(of: " >", with: "")
    }
    
    override func relayoutSubViews() {
        relayoutCommon()
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHBaseTBCell.self)
        tableView.register(cellWithClass: XWHExpandBaseTBCell.self)
    }
    
    @objc func configQuestions() {
        questions = [
            ["原因一：手机网络连接异常", "解决方案：重新连接网络"],
            ["原因二：手表蓝牙连接异常", "解决方案：请尝试关闭手机系统蓝牙开关，然后重新开启，在再APP我的页面点击连接"],
            ["原因三：已经配对", "解决方案：请查看当前手机蓝牙系统是否已经配对上了(蓝牙名称后面有个符号ⓘ)，如已配对，可点击符合进入下一级界面，点击忽略设备，才能再次扫描到设备"],
            ["原因四：被其他手机App连接了", "解决方案：解绑其他手机或App"],
        ]
        expandStates = questions.map({ _ in false })
    }
    
}


// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHDeviceConnectBindHelpTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return expandStates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandStates[section] {
            return 2
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 52
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHExpandBaseTBCell.self, for: indexPath)
            cell.titleLb.text = questions[indexPath.section][0]
            cell.isOpen = expandStates[indexPath.section]
            cell.relayoutSubViews(leftRightInset: 28)
            cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHBaseTBCell.self, for: indexPath)
            cell.titleLb.text = questions[indexPath.section][1]
            
            cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
            cell.titleLb.numberOfLines = 0

            return cell
        }
    }
    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 52
        }
        
        return 0.001
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableCell(withClass: XWHBaseTBCell.self)
            header.titleLb.text = "设备与手机无法重新连接"
            header.titleLb.font = XWHFont.harmonyOSSans(ofSize: 22, weight: .bold)
            
            return header
        }
        
        return nil
    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            expandStates[indexPath.section] = !expandStates[indexPath.section]
            
            tableView.reloadData()
        }
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}
