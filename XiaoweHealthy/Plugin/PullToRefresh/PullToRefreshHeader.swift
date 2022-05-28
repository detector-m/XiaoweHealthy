//
//  PullToRefreshHeader.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/28.
//

import UIKit
import MJRefresh

class PullToRefreshHeader: MJRefreshStateHeader {
    
    private lazy var contentOffset: CGFloat = 0
    
    convenience init(refreshingBlock: @escaping MJRefreshComponentAction, contentOffset: CGFloat) {
        self.init(refreshingBlock: refreshingBlock)
        self.contentOffset = contentOffset
    }

    override func placeSubviews() {
        super.placeSubviews()

        guard let stateLabel = self.stateLabel, !stateLabel.isHidden else {
            return
        }
        
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0;
//        let contentOffset = UIApplication.shared.statusBarFrame.height
        
        guard let lastUpdatedTimeLabel = self.lastUpdatedTimeLabel, !lastUpdatedTimeLabel.isHidden else {
            // 状态
            if noConstrainsOnStatusLabel
                {
                stateLabel.frame = CGRect(x: 0, y: contentOffset, width: bounds.width, height: bounds.height - contentOffset)
            }
            
            return
        }
    
        let stateLabelH = (mj_h - contentOffset) * 0.5
        // 状态
        if noConstrainsOnStatusLabel {
            stateLabel.mj_x = 0
            stateLabel.mj_y = contentOffset
            stateLabel.mj_w = mj_w
            stateLabel.mj_h = stateLabelH
        }
        
        // 更新时间
        if lastUpdatedTimeLabel.constraints.count == 0 {
            lastUpdatedTimeLabel.mj_x = 0
            lastUpdatedTimeLabel.mj_y = stateLabelH + stateLabel.mj_y
            lastUpdatedTimeLabel.mj_w = mj_w
            lastUpdatedTimeLabel.mj_h = mj_h - lastUpdatedTimeLabel.mj_y
        }
    }

}
