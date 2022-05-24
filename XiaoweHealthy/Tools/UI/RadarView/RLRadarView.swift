//
//  RLRadarView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

let RADAR_DEFAULT_CENTERVIEW_RADIUS: CGFloat = 70 //默认中心视图半径大小
let RADAR_DEFAULT_CIRCLE_NUM: Int = 2 //默认圈数
let RADAR_DEFAULT_CIRCLE_INCREMENT: CGFloat = 70 //默认圈与圈的增长量
let RADAR_DEFAULT_RADIUS: CGFloat = 140 //默认指针半径大小

class RLRadarView: UIView {

    public var indicatorViewRadius: CGFloat = 0.0 //指针半径
    public var centerViewRadius: CGFloat = 0.0 //中间视图半径
    public var circleNum: Int = 0 //圈与圈的增长量
    public var circleIncrement: CGFloat = 0 //圈的个数
    
//    public var bgImage: UIImage? //背景图片
    
    lazy var radarIndicatorView: RLRadarIndicatorView = {
        let radarIndicatorView = RLRadarIndicatorView()
        return radarIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        addSubview(radarIndicatorView)
        
        backgroundColor = .white
        
        initData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        indicatorViewRadius = rect.width / 2
        circleIncrement = indicatorViewRadius / 2
        centerViewRadius = circleIncrement * 1.5
        
        let circelBgColor = UIColor(hex: 0x80F498)!
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradientColors = [circelBgColor.withAlphaComponent(0.2).cgColor, UIColor.white.cgColor]
        let gradientLocations: [CGFloat] = [0, 0.6]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: gradientLocations)

        let context = UIGraphicsGetCurrentContext()

//        let path = CGMutablePath()
//        path.addArc(center: rect.center, radius: centerViewRadius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
//        context?.addPath(path)
        
        context?.setLineWidth(circleIncrement)
        context?.addArc(center: rect.center, radius: centerViewRadius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)

        context?.replacePathWithStrokedPath()
        context?.clip()
        
        if let cGradient = gradient {
            let startPoint = CGPoint(x: rect.width / 2, y: rect.height)
            let endPoint = CGPoint(x: rect.width / 2, y: 0)
            
            context?.drawLinearGradient(cGradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        }
        
        radarIndicatorView.clipsToBounds = false
        radarIndicatorView.frame = CGRect(x: 0, y: 0, width: 2 * indicatorViewRadius, height: rect.height)
        radarIndicatorView.center = rect.center
        radarIndicatorView.radius = indicatorViewRadius
        radarIndicatorView.backgroundColor = UIColor.clear
    }
    
//    override open func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        log.debug("视图开始绘制")
//
//        //背景图片
//        bgImage?.draw(in: rect)
//
//        indicatorViewRadius = rect.width / 2
//
//        //中间视图
////        let centerView = UIImageView(frame: CGRect(x: self.center.x - self.centerViewRadius, y: self.center.y - self.centerViewRadius, width: 2 * self.centerViewRadius, height: 2 * self.centerViewRadius))
////        centerView.backgroundColor = UIColor.lightGray
////        if centerViewImage != nil {
////            centerView.image = self.centerViewImage
////        }
////        centerView.layer.cornerRadius = self.centerViewRadius
////        centerView.layer.masksToBounds = true
//
//        //圆与圆之间间隔距离
//        let space = (self.indicatorViewRadius - self.centerViewRadius - self.getIncrement()) / CGFloat(self.circleNum)
////        var sectionRadius = space + self.centerViewRadius
//
//        var sectionRadius: CGFloat = 0
//
////        self.addSubview(centerView)
//
//        let circelBgColor = UIColor(hex: 0x80F498)!
////        let circelBgColor = UIColor.white
//
//        for i in (1 ... circleNum).reversed() {
//            sectionRadius = centerViewRadius + (space + circleIncrement) * CGFloat(i - 1)
//
//            let cAlpha: CGFloat = CGFloat(i - 1) / CGFloat(circleNum) * 0.6
//
//            let context = UIGraphicsGetCurrentContext()
//
//            //颜色为白色，透明度渐变
////            context?.setStrokeColor(circelBgColor.withAlphaComponent((CGFloat(i) / CGFloat(circleNum)) * 0.6).cgColor)
////            context?.setLineWidth(1.0)
//            let path = CGMutablePath()
//            path.addArc(center: rect.center, radius: sectionRadius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
//            context?.addPath(path)
////            context?.strokePath()
//
//            context?.setFillColor(UIColor.white.cgColor)
//            context?.fillPath()
//
//            context?.addPath(path)
//            context?.setFillColor(circelBgColor.withAlphaComponent(cAlpha).cgColor)
//            context?.fillPath()
//        }
//
//        radarIndicatorView.clipsToBounds = false
//        radarIndicatorView.frame = CGRect(x: 0, y: 0, width: 2 * indicatorViewRadius, height: rect.height)
//        radarIndicatorView.center = rect.center
//        radarIndicatorView.radius = indicatorViewRadius
//        radarIndicatorView.backgroundColor = UIColor.clear
//    }
    
}

//MARK: - 公共方法
extension RLRadarView {
    
    // 显示雷达扫描
    // view:父视图
//    public func showInView(view: UIView) {
//        frame = view.bounds
//
//        view.addSubview(self)
//
//        scan()
//    }
    
    
    // 开始扫描
    public func scan() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 2 * Double.pi
        animation.duration = 3
        animation.autoreverses = false
        animation.repeatCount = Float.greatestFiniteMagnitude
        radarIndicatorView.layer.add(animation, forKey: nil)
    }
    
    // 停止扫描
    public func stop() {
        radarIndicatorView.layer.removeAllAnimations()
    }
    
}

//MARK: - 私有方法
extension RLRadarView {
    
    // 初始化数据
    private func initData() {
        indicatorViewRadius = RADAR_DEFAULT_RADIUS
        centerViewRadius = RADAR_DEFAULT_CENTERVIEW_RADIUS
        circleNum = RADAR_DEFAULT_CIRCLE_NUM
        circleIncrement = RADAR_DEFAULT_CIRCLE_INCREMENT
    }
    
    // 获取圈与圈的增长总量
    private func getIncrement() -> CGFloat {
        var increment: CGFloat = 0.0
        for i in 1 ..< circleNum {
            increment += CGFloat(i) * circleIncrement
        }
        
        return increment
    }
    
}
