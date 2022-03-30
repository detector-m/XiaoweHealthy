//
//  UITableViewRoundedProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import Foundation


protocol UITableViewRoundedProtocol {
    
    // MARK: - Cell
    func rounded(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    func rounded(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, cornerRadius: CGFloat, bgColor: UIColor)
    
    /// cell 画圆角
    /// 使用前，需要调整好行约束间距
    /// - Parameters:
    ///     - cornerRadius: 圆角半径
    ///     - insetBy: dx：左右偏移量，dy：上下偏移量
    ///     - allDraw: 是否四个边角全部绘制
    func rounded(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, cornerRadius: CGFloat, bgColor: UIColor, insetBy:(dx: CGFloat, dy: CGFloat), allDraw: Bool)
    
    // MARK: -
    
    func rounded(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    /// HeaderView 画圆角
    /// - Parameters:
    ///     - cornerRadius: 圆角半径
    func rounded(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int, cornerRadius: CGFloat)
    
}

extension UITableViewRoundedProtocol {
    
    func rounded(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath, cornerRadius: 16, bgColor: .white)
    }
    
    func rounded(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, cornerRadius: CGFloat, bgColor: UIColor) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath, cornerRadius: cornerRadius, bgColor: bgColor, insetBy: (dx: 0, dy: 0), allDraw: false)
    }

    func rounded(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, cornerRadius: CGFloat, bgColor: UIColor, insetBy:(dx: CGFloat, dy: CGFloat), allDraw: Bool) {
        //圆角半径
//        let cornerRadius: CGFloat = 12.0
        // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
        cell.backgroundColor = .clear
        
        // 创建一个shapeLayer
        let layer: CAShapeLayer = CAShapeLayer()           //默认样式
        let backgroundLayer: CAShapeLayer = CAShapeLayer() //选中样式
        // 获取cell的size
        // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
        let bounds = cell.bounds.insetBy(dx: insetBy.dx, dy: insetBy.dy)
        // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
        let row: NSInteger = indexPath.row
        //最后一行
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1

        var maskPath: UIBezierPath = UIBezierPath()
        let cornerSize: CGSize = CGSize.init(width: cornerRadius, height: cornerRadius)
        
        if allDraw {
            maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerSize)
        }
        else {
            // headerView
//            if let _ = tableView.delegate?.tableView?(tableView, viewForHeaderInSection: indexPath.section) {
//                // 如果即使第一行也是最后一行,只有一个cell 四个圆角
//                if (row == 0 && row == lastRow) {
//                    maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerSize)
//                } else if (row == lastRow) { // 最后一行
//                    maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerSize)
//                } else {
//                    // 添加cell的rectangle信息到path中（不包括圆角）
//                    maskPath = UIBezierPath(rect: bounds)
//                }
//            } else {
//                
//            }
            
            // 如果即使第一行也是最后一行,只有一个cell 四个圆角
            if (row == 0 && row == lastRow) {
                maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerSize)
            } else if(row == 0) { // 第一行
                maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerSize)
            } else if (row == lastRow) { // 最后一行
                maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerSize)
            } else {
                // 添加cell的rectangle信息到path中（不包括圆角）
                maskPath = UIBezierPath(rect: bounds)
            }
        }
        
        layer.path = maskPath.cgPath
        backgroundLayer.path = maskPath.cgPath
        
        // 按照shape layer的path填充颜色，类似于渲染render
        layer.fillColor = bgColor.cgColor
        
        // view大小与cell一致
        let roundView = UIView.init(frame: bounds)
        // 添加自定义圆角后的图层到roundView中
        roundView.layer.insertSublayer(layer, at: 0)
        roundView.backgroundColor = .clear
        // cell的背景view
        cell.backgroundView = roundView
        
        //最后一行 不添加 下划线
//            if (indexPath.row != lastRow) {
//                //添加横线
//
//                let lineLayer = CALayer()
//                let lineHeight = 1.0 / UIScreen.main.scale
//                lineLayer.frame = CGRect.init(x: cell.separatorInset.left, y: bounds.size.height - lineHeight, width: bounds.size.width - (cell.separatorInset.left + cell.separatorInset.left), height: lineHeight)
//                lineLayer.backgroundColor = addInfoTableView.separatorColor?.cgColor
//                layer.addSublayer(lineLayer)
//            }
//
        // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
        // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
//            let selectedBackgroundView = UIView.init(frame: bounds)
//            backgroundLayer.fillColor = ToolHelper.swift_RGB(212, g: 212, b: 212).cgColor
//            selectedBackgroundView.layer.insertSublayer(backgroundLayer, at: 0)
//            selectedBackgroundView.backgroundColor = .clear
//            cell.selectedBackgroundView = selectedBackgroundView
    }
    
    // MARK: -
    func rounded(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        rounded(tableView, willDisplayHeaderView: view, forSection: section, cornerRadius: 12)
    }
    
    /// HeaderView 画圆角
    /// - Parameters:
    ///     - cornerRadius: 圆角半径
    func rounded(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int, cornerRadius: CGFloat) {
        let cRect = view.bounds
        // 绘制曲线
        // 为组的第一行时，左上、右上角为圆角
        let bezierPath = UIBezierPath(roundedRect: cRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        // 新建一个图层
        let cLayer: CAShapeLayer = CAShapeLayer()
        
        // 图层边框路径
        cLayer.path = bezierPath.cgPath
        view.layer.mask = cLayer
    }
    
}
