//
//  PullToRefreshHeader.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/28.
//

import UIKit
import MJRefresh

class PullToRefreshHeader: MJRefreshStateHeader {
    
    private lazy var imageView: UIImageView = {
        let _imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        _imageView.layer.cornerRadius = 16
        _imageView.layer.backgroundColor = btnBgColor.withAlphaComponent(0.10).cgColor
        _imageView.contentMode = .center
        _imageView.image = R.image.loading()?.scaled(toWidth: 22)
        
        return _imageView
    }()
    
    private var imageSize: CGFloat {
        return 32
    }
    private lazy var contentOffset: CGFloat = 0
    
    convenience init(refreshingBlock: @escaping MJRefreshComponentAction, contentOffset: CGFloat) {
        self.init(refreshingBlock: refreshingBlock)
        self.contentOffset = contentOffset
    }
    
    override func prepare() {
        super.prepare()
        
        addSubview(imageView)
    }

    override func placeSubviews() {
        super.placeSubviews()

        imageView.frame = CGRect(x: (bounds.width - imageSize) / 2, y: contentOffset + 5, width: imageSize, height: imageSize)
        guard let stateLabel = self.stateLabel, !stateLabel.isHidden else {
            return
        }
        
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0;
//        let contentOffset = UIApplication.shared.statusBarFrame.height
        
        guard let lastUpdatedTimeLabel = self.lastUpdatedTimeLabel, !lastUpdatedTimeLabel.isHidden else {
            // 状态
            if noConstrainsOnStatusLabel
                {
                stateLabel.frame = CGRect(x: 0, y: contentOffset + imageSize + 10, width: bounds.width, height: bounds.height - contentOffset - imageSize - 15)
            }
            
            return
        }
    
//        let stateLabelH = (mj_h - contentOffset) * 0.5
        let stateLabelH = (mj_h - contentOffset - 10 - imageSize)
        // 状态
        if noConstrainsOnStatusLabel {
            stateLabel.mj_x = 0
            stateLabel.mj_y = contentOffset + imageSize + 10
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
    
    override func beginRefreshing() {
        startAnimation()
        super.beginRefreshing()
    }
    
    override func endRefreshing() {
        stopAnimation()
        super.endRefreshing()
    }
    
    private func startAnimation() {
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.duration = 0.5;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = .infinity;
        rotationAnimation.isRemovedOnCompletion = false
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopAnimation() {
        imageView.layer.removeAllAnimations()
    }

}
