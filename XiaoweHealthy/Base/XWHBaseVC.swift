//
//  XWHBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHBaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupNavigationItems()
        addSubViews()
        relayoutSubViews()
    }
    
    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = getNavGlobalBackItem()
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
        let button = UIButton(type: .custom)
        button.setImage(R.image.globalBack(), for: .normal)
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }

}
