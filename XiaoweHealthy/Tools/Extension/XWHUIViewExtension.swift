//
//  XWHUIViewExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/21.
//

import Foundation
import UIKit

// MARK: - Toast-swift
extension UIView {
    
    func makeInsetToast(_ message: String?, duration: TimeInterval = ToastManager.shared.duration, inset: CGFloat = 76, title: String? = nil, image: UIImage? = nil, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)? = nil) {
        do {
            let toast = try toastViewForMessage(message, title: title, image: image, style: style)
            
            let topPadding: CGFloat = style.verticalPadding + safeAreaInsets.top + inset
            let bottomPadding: CGFloat = ToastManager.shared.style.verticalPadding + safeAreaInsets.bottom + inset
            
            var cPoint = CGPoint()
            switch ToastManager.shared.position {
            case .top:
                cPoint = CGPoint(x: bounds.size.width / 2.0, y: (toast.frame.size.height / 2.0) + topPadding)
            case .center:
                cPoint = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
            case .bottom:
                cPoint = CGPoint(x: bounds.size.width / 2.0, y: (bounds.size.height - (toast.frame.size.height / 2.0)) - bottomPadding)
            }
            
            showToast(toast, duration: duration, point: cPoint, completion: completion)
        } catch {
            print("Error: message, title, and image cannot all be nil")
        }
    }
    
//    func makeXWHToast(_ message: String) {
//        let bottomPadding: CGFloat = ToastManager.shared.style.verticalPadding + safeAreaInsets.bottom + 94
//
//        let cPoint = CGPoint(x: bounds.width / 2.0, y: bounds.height - bottomPadding)
//        makeToast(message, point: cPoint, title: nil, image: nil, completion: nil)
//    }
    
}
