//
//  PullToRefreshExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/28.
//

import Foundation
import MJRefresh

typealias PullToRefreshRefreshingBlock = () -> Void

// MARK: - MJRefresh 的拓展
extension UIScrollView {
    
    /// 添加头部刷新
    /// - Parameters:
    ///     - refreshingBlock: 刷新回调
    @discardableResult
    func addHeader(contentInsetTop: CGFloat = 0, contentOffset: CGFloat = 0, refreshingBlock: @escaping PullToRefreshRefreshingBlock) -> PullToRefreshHeader {
        let header = PullToRefreshHeader(refreshingBlock: refreshingBlock, contentOffset: contentOffset)
        header.ignoredScrollViewContentInsetTop = contentInsetTop
        
        header.mj_h = 64
        
        // 设置字体
        header.stateLabel?.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        header.stateLabel?.textColor = fontDarkColor
        header.lastUpdatedTimeLabel?.isHidden = true
        
        // 设置文字
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("设备连接中...", for: .refreshing)

        //        header.arrowView.image =
        
        mj_header = header
        
        return header
    }
    
    /// 添加脚部刷新
    /// - Parameters:
    ///     - refreshingBlock: 刷新回调
    @discardableResult
    func addFooter(refreshingBlock: @escaping PullToRefreshRefreshingBlock) -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
        
        footer.stateLabel?.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        footer.stateLabel?.textColor = fontDarkColor
        
        footer.setTitle("加载中...", for: .refreshing)
        footer.setTitle("没有更多了", for: .noMoreData)
        
        mj_footer = footer
        
        return footer
    }
    
}
