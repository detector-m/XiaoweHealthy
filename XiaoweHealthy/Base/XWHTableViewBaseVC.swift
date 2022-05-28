//
//  XWHTableViewBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import UIKit

class XWHTableViewBaseVC: XWHBaseVC {
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerViews()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = bgColor
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
                
        view.addSubview(tableView)
    }
    
    override func setLargeTitleMode() {
        isUseLargeTitleMode = true
        
        // 大标题方式2
        setLargeTitleModeSecond()
    }
    
    /// 设置第二种方式
    final func setLargeTitleModeSecond() {
        tableView.addSubview(largeTitleView)
        setTopInsetForLargeTitle(in: tableView)
    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func relayoutLargeTitle() {
        relayoutLargeTitleSecond()
    }
    
    final func relayoutCommon() {
        // 大标题方式2
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitleSecond()
        relayoutLargeTitleContentView()
    }
    
    final func relayoutLargeTitleSecond() {
        largeTitleView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(largeTitleWidth)
            make.top.equalToSuperview().inset(-largeTitleHeight)
            make.height.equalTo(largeTitleHeight)
        }
    }
    
    func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(28)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(28)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    @objc func registerViews() {
        
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHTableViewBaseVC : UITableViewDataSource, UITableViewDelegate, UITableViewRoundedProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }

    
}
