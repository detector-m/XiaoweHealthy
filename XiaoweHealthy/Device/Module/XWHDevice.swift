//
//  XWHDevice.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation

class XWHDevice {
    
    // MARK: - UI
    class func gotoHelp(at targetVC: UIViewController) {
        XWHSafari.present(at: targetVC, urlStr: kRedirectURL)
    }
    
    class func getRootVC() -> UIViewController {
        if XWHUser.isLogined(), let _ = XWHDataDeviceManager.getCurrentWatch() {
            return XWHDeviceMainVC()
        }
        
        return XWHAddDeviceEntryVC()
    }
    
    static var isDevConnectBind: Bool {
        XWHDDMShared.connectBindState == .paired
    }
    
    // 心率设置
    class func gotoDevSetHeart(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        let vc = XWHDevSetHeartVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血氧饱和度设置
    class func gotoDevSetBloodOxygen(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetBloodOxygenVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 久坐提醒
    class func gotoDevSetStand(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetStandVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血压设置
    class func gotoDevSetBloodPressure(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetBloodPressureVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 精神压力设置
    class func gotoDevSetMentalStress(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetMentalStressVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Api
    
    
}
