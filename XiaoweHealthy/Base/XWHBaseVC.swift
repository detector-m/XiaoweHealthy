//
//  XWHBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHBaseVC: UIViewController {
    
    lazy var largeTitleView = XWHLargeTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = bgColor
        
        setupNavigationItems()
        addSubViews()
        relayoutSubViews()
    }
    
    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = getNavGlobalBackItem()
        rt_disableInteractivePop = false
    }
    
    func addSubViews() {
        
    }
    
    func relayoutSubViews() {
        
    }
    
    func getNavGlobalBackItem() -> UIBarButtonItem {
        return getNavGlobalBackItem(target: self, action: #selector(clickNavGlobalBackBtn))
    }
    
    @objc func clickNavGlobalBackBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    func getNavGlobalBackItem(target: UIViewController, action: Selector) -> UIBarButtonItem {
        return getNavItem(text: nil, image: R.image.globalBack(), target: target, action: action)
    }
    
    func getNavItem(text: String? = nil, image: UIImage? = nil, target: UIViewController, action: Selector) -> UIBarButtonItem {
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
    
}
