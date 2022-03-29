//
//  RLRadarIndicatorView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

class RLRadarIndicatorView: UIView {
    
    var radius: CGFloat = 0.0
    var iColor = UIColor(hex: 0x80F498)!
    
    override func draw(_ rect: CGRect) {
        log.debug("开始绘制指针")
        
        let context = UIGraphicsGetCurrentContext()
        let whiteColor = UIColor.white.withAlphaComponent(0.8)
        context?.setFillColor(whiteColor.cgColor)
        context?.setLineWidth(0)
        context?.move(to: CGPoint(x: rect.width / 2, y: center.y))
        context?.addArc(center: CGPoint(x: rect.width / 2, y: center.y), radius: self.radius, startAngle: CGFloat(-90.5 * .pi / 180), endAngle: CGFloat(-90 * Double.pi / 180), clockwise: false)
        context?.closePath()
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        for i in 0...270 {
            let color = iColor.withAlphaComponent(CGFloat(i) / 500)
            
            context?.setFillColor(color.cgColor)
            context?.setLineWidth(0)
            context?.move(to: CGPoint(x: rect.width / 2, y: self.center.y))
            context?.addArc(center: CGPoint(x: rect.width / 2, y: self.center.y), radius: self.radius, startAngle: CGFloat(Double(-360 + i) * Double.pi / 180), endAngle: CGFloat(Double(-360 + i - 1) * Double.pi / 180), clockwise: true)
            context?.closePath()
            context?.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }

}
