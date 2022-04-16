//
//  XWHProgressButton.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/2.
//

import UIKit
import LinearProgressBar

class XWHProgressButton: UIButton {

    lazy var progressView = LinearProgressBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        progressView.frame = bounds
        
        progressView.isUserInteractionEnabled = false
        progressView.trackPadding = 0
        progressView.backgroundColor = .clear
        addSubview(progressView)
        
        sendSubviewToBack(progressView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressView.barThickness = height
        progressView.frame = bounds
    }
    
}
