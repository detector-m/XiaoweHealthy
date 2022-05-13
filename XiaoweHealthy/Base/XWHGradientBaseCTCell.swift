//
//  XWHGradientBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit

class XWHGradientBaseCTCell: XWHCommonBaseCTCell {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        gradientLayer.cornerRadius = 12
        return gradientLayer
    }()
    
    lazy var gradientColors: [UIColor] = [UIColor(hex: 0xFFE0E2)!, UIColor(hex: 0xFFFFFF)!] {
        didSet {
            gradientLayer.colors = gradientColors.map({ $0.cgColor })
        }
    }
    lazy var isHorizontal = true {
        didSet {
            if isHorizontal {
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            } else {
                gradientLayer.startPoint = CGPoint(x: 1, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            }
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
    
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
}
