//
//  XWHSportInMotionVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit

/// 运动中
class XWHSportInMotionVC: XWHBaseVC {
    
    lazy var mapView = UIView()
    
    /// 控制面板
    lazy var controlPanel = XWHSportControlPanel()
    
    private var panelHeight: CGFloat {
        return 508
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        relayoutSubViews()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()

        setNavTransparent()
    }
    
    override func clickNavGlobalBackBtn() {
        navigationController?.dismiss(animated: true)
    }
    
    override func addSubViews() {
        view.addSubview(mapView)
        view.addSubview(controlPanel)
        
        mapView.backgroundColor = btnBgColor
        
        controlPanel.layer.cornerRadius = 16
        controlPanel.layer.backgroundColor = UIColor.white.cgColor
        controlPanel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        controlPanel.update()
    }
    
    override func relayoutSubViews() {
        mapView.frame = view.bounds
        
        controlPanel.frame = CGRect(x: 0, y: view.height - panelHeight, width: view.width, height: panelHeight)
    }

}
