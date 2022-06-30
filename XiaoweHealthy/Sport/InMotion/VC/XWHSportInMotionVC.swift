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
    
    // 运动控制
    lazy var timeManager = TimeManager(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlPanel.update(time: 0)
        DispatchQueue.main.async { [weak self] in
            self?.start()
        }
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
        controlPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        configEvent()
    }
    
    override func relayoutSubViews() {
        mapView.frame = view.bounds
        
        controlPanel.frame = CGRect(x: 0, y: view.height - panelHeight, width: view.width, height: panelHeight)
    }
    
    private func configEvent() {
        controlPanel.stopCompletion = { [unowned self] in
            self.stop()
        }
        
        controlPanel.pauseCompletion = { [unowned self] in
            self.pause()
        }
        
        controlPanel.continueCompletion = { [unowned self] in
            self.resume()
        }
        
        controlPanel.unlockCompletion = { [unowned self] in
            
        }
    }

}

// MARK: - 运动控制
extension XWHSportInMotionVC {
    
    func start() {
        timeManager.start()
    }
    
    func stop() {
        timeManager.stop()
    }
    
    func pause() {
        timeManager.pause()
    }
    
    func resume() {
        timeManager.resume()
    }
    
}

extension XWHSportInMotionVC: TimeManagerProtocol {
    
    func clockTick(time: Int) {
        controlPanel.update(time: time)
    }
    
}
