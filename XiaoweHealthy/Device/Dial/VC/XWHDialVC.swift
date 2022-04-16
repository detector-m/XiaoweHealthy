//
//  XWHDialVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit
import Tabman
import Pageboy


// MARK: - 表盘控制器
class XWHDialVC: TabmanViewController {
    
    private class XWHBlockBarIndicator: TMBlockBarIndicator {
        
        lazy var contentView = UIView()
        
        // MARK: Lifecycle
        
        open override func layout(in view: UIView) {
            super.layout(in: view)
            
            backgroundColor = nil
            addSubview(contentView)
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            layer.cornerRadius = 0
            
            contentView.frame = bounds.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
            contentView.layer.cornerRadius = cornerRadius(for: contentView.bounds)
        }
        
        func cornerRadius(for frame: CGRect) -> CGFloat {
            switch cornerStyle {
            case .square:
                return 0.0
            case .rounded:
                return frame.size.height / 6.0
            case .eliptical:
                return frame.size.height / 2.0
            }
        }
        
    }
    
    // MARK: Properties
    // 设备标识
    lazy var deviceSn: String = "" {
        didSet {
            pageItems.forEach { item in
                let vc = item.1 as? XWHDialContentBaseVC
                vc?.deviceSn = deviceSn
            }
        }
    }
    
    private lazy var pageItems: [(String, UIViewController)] = {
        let myDialVC = XWHMyDialVC()
        let dialMarketVC = XWHDialMarketVC()
        
        return [(R.string.xwhDialText.我的表盘(), myDialVC),
                (R.string.xwhDialText.表盘市场(), dialMarketVC)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = bgColor
        
        setNav(color: bgColor)
        
        setupNavigationItems()
        configPageController()
    }
    
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = getNavGlobalBackItem()
        rt_disableInteractivePop = true
    }
    
    private func getNavGlobalBackItem() -> UIBarButtonItem {
        return getNavGlobalBackItem(target: self, action: #selector(clickNavGlobalBackBtn))
    }
    
    @objc private func clickNavGlobalBackBtn() {
        navigationController?.popViewController(animated: true)
        resetNavFromTransparent()
    }
    
    private func getNavGlobalBackItem(target: UIViewController, action: Selector) -> UIBarButtonItem {
        return getNavItem(text: nil, image: R.image.globalBack(), target: target, action: action)
    }
    
    private func getNavItem(text: String? = nil, image: UIImage? = nil, target: UIViewController, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        if let cImage = image {
            button.setImage(cImage, for: .normal)
        } else if let cText = text {
            button.setTitle(cText, for: .normal)
            button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14)
            button.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        }
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func configPageController() {
        // Set PageboyViewControllerDataSource dataSource to configure page view controller.
        dataSource = self
        
        // Create a bar
//        let bar = TMBarView.ButtonBar()
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, XWHBlockBarIndicator>()
        
        // Customize bar properties including layout and other styling.
        bar.layout.contentInset = UIEdgeInsets(top: 2, left: 18, bottom: 2, right: 18)
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 2

        bar.indicator.isHidden = false
        bar.indicator.cornerStyle = .eliptical
        bar.indicator.contentView.backgroundColor = bgColor
        
        bar.spacing = 16
        bar.scrollMode = .none
//        bar.layer.cornerRadius = 22
//        bar.layer.backgroundColor = dialBarBgColor.cgColor
        
        bar.backgroundView.style = .custom(view: getBgView())
        
        
        // Set tint colors for the bar buttons and indicator.
        bar.buttons.customize {
            $0.tintColor = fontDarkColor
            $0.selectedTintColor = fontDarkColor
            $0.adjustsFontForContentSizeCategory = true
            $0.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        }
        
        // Add bar to the view - as a .systemBar() to add UIKit style system background views. -> bar.systemBar()
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func getBgView() -> UIView {
        let bgView = UIView()
        let contentView = UIView()
        bgView.backgroundColor = bgColor
        bgView.addSubview(contentView)
        contentView.layer.cornerRadius = 22
        contentView.layer.backgroundColor = dialBarBgColor.cgColor
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview().inset(2)
        }
        return bgView
    }
    
}

extension XWHDialVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    // MARK: - PageboyViewControllerDataSource
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        // How many view controllers to display in the page view controller.
        pageItems.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        // View controller to display at a specific index for the page view controller.

        pageItems[index].1
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        // Default page to display in the page view controller (nil equals default/first index).
        .last
    }
    
    // MARK: - TMBarDataSource
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: pageItems[index].0) // Item to display for a specific index in the bar.
    }
    
}
