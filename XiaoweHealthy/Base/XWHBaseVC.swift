//
//  XWHBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHBaseVC: UIViewController {
    
    lazy var largeTitleView = XWHLargeTitleView()
    var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var largeTitleHeight: CGFloat {
        64
    }
    
    // 大标题处理方式 方式1
    // largeTitleView 顶部约束
    var topConstraint: Constraint?
    
    // 大标题处理方式 方式2
    var topContentInset: CGFloat {
        66
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        
        view.backgroundColor = bgColor
        
        setNavTransparent()
        
        setupNavigationItems()
        addSubViews()
        relayoutSubViews()
    }
    
    @objc func setupNavigationItems() {
        setNavGlobalBackItem()
    }
    
    // 设置大标题模式
    @objc func setLargeTitleMode() {
        setLargeTitleModeFirst()
    }
    
    /// 设置第一种方式 默认
    final func setLargeTitleModeFirst() {
        view.addSubview(largeTitleView)
    }
    
    // 设置带有LargeTitle的nav items
    @objc func setNavigationBarWithLargeTitle() {
        setNav(color: bgColor)
    }
    
    // 还原没有LargeTitle的 nav itmes
    @objc func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
    }
    
    @objc func addSubViews() {
        
    }
    
    @objc func relayoutSubViews() {
        
    }
    
    @objc func relayoutLargeTitle() {
        relayoutLargeTitleFirst()
    }
    
    final func relayoutLargeTitleFirst() {
        // 大标题方式1
        largeTitleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            topConstraint = make.top.equalTo(topContentInset).constraint
            make.height.equalTo(largeTitleHeight)
        }
    }
    
    @objc func setNavGlobalBackItem() {
        navigationItem.leftBarButtonItem = getNavGlobalBackItem()
        rt_disableInteractivePop = false
    }
    
    @objc func getNavGlobalBackItem() -> UIBarButtonItem {
        return getNavGlobalBackItem(target: self, action: #selector(clickNavGlobalBackBtn))
    }
    
    @objc func clickNavGlobalBackBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func getNavGlobalBackItem(target: UIViewController, action: Selector) -> UIBarButtonItem {
        return getNavItem(text: nil, image: R.image.globalBack(), target: target, action: action)
    }
    
    @objc func getNavItem(text: String? = nil, font: UIFont? = nil, color: UIColor? = nil, image: UIImage? = nil, target: UIViewController, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        if let cImage = image {
            button.setImage(cImage, for: .normal)
        } else if let cText = text {
            button.setTitle(cText, for: .normal)
            if let font = font {
                button.titleLabel?.font = font
            } else {
                button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14)
            }
            if let color = color {
                button.setTitleColor(color, for: .normal)
            } else {
                button.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
            }
        }
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
}

@objc extension XWHBaseVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(atTop: scrollView)
    }
    
}

// MARK: - 处理大标题滚动的方式
@objc extension XWHBaseVC {
    
    // MARK: - 方式1
    /// 通过在scrollview 的上部控制滚动大标题 （topConstraint 控制）
    /// - Parameters:
    ///     - scrollView: 滚动的view
    func handleScrollLargeTitle(atTop scrollView: UIScrollView) {
        guard let cTopConstraint = topConstraint else {
            return
        }
        
        guard let _ = navigationController else {
            return
        }
        
        let topInsetMax: CGFloat = 66
        let topInsetMin: CGFloat = -40
        let sContentOffset = scrollView.contentOffset.y
        var curInset: CGFloat = topInsetMax - sContentOffset
        
        if curInset >= topInsetMax {
            curInset = topInsetMax
        } else if curInset <= topInsetMin {
            curInset = topInsetMin
        }
        
        if sContentOffset >= largeTitleHeight {
            setNavigationBarWithLargeTitle()
        } else {
            resetNavigationBarWithoutLargeTitle()
        }
        
        cTopConstraint.update(inset: curInset)
    }
    
    // MARK: - 方式2
    /// 设置 scrollview的上部内嵌
    func setTopInsetForLargeTitle(in scrollView: UIScrollView) {
        if largeTitleView.superview != scrollView {
            largeTitleView.removeFromSuperview()
            scrollView.addSubview(largeTitleView)
        }
        
        var oInset = scrollView.contentInset
        oInset.top += topContentInset + largeTitleHeight
        scrollView.contentInset = oInset
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.contentOffset = CGPoint(x: 0, y: -oInset.top)
    }
    
    /// 通过添加到 scrollview 中控制滚动大标题
    /// - Parameters:
    ///     - scrollView: 滚动的view
    func handleScrollLargeTitle(in scrollView: UIScrollView) {
        guard let _ = navigationController else {
            return
        }
        
//        let topInsetMax: CGFloat = 66
//        let topInsetMin: CGFloat = -40
        let sContentOffset = scrollView.contentOffset.y
//        var curInset: CGFloat = topInsetMax - sContentOffset
        
//        if curInset >= topInsetMax {
//            curInset = topInsetMax
//        } else if curInset <= topInsetMin {
//            curInset = topInsetMin
//        }
        
        if sContentOffset >= -topContentInset {
            setNavigationBarWithLargeTitle()
        } else {
            resetNavigationBarWithoutLargeTitle()
        }
    }
    
}
