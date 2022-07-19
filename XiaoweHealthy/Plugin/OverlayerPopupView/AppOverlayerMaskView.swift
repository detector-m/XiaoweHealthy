//
//  AppOverlayerMaskView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import Foundation

public class AppOverlayerMaskView: UIControl {
    
    public enum BackgroundStyle {
        case solidColor
        case blur
    }

    public var style = BackgroundStyle.blur {
        didSet {
            refreshBackgroundStyle()
        }
    }
    public var blurEffectStyle = UIBlurEffect.Style.dark {
        didSet {
            refreshBackgroundStyle()
        }
    }
    /// 无论style是什么值，color都会生效。如果你使用blur的时候，觉得叠加上该color过于黑暗时，可以置为clearColor。
    public var color = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            backgroundColor = color
        }
    }
    var effectView: UIVisualEffectView?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        refreshBackgroundStyle()
        backgroundColor = color
        layer.allowsGroupOpacity = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == effectView {
            //将event交给backgroundView处理
            return self
        }
        return view
    }

    func refreshBackgroundStyle() {
        effectView?.removeFromSuperview()

        if style == .solidColor {
            effectView = nil
        } else {
            effectView = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
            effectView?.frame = bounds
            addSubview(effectView!)
        }
    }
    
}
