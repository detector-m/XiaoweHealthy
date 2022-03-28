//
//  XWHSafari.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/27.
//

import Foundation
import SafariServices

struct XWHSafari {
    
    static func present(at vc: UIViewController, urlStr: String) {
        let cUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`%^{}\"[]|\\<> ").inverted)
        guard let url = cUrlStr?.url else {
            return
        }
        
        let sf = SFSafariViewController(url: url)
        sf.view.backgroundColor = .white
        sf.preferredBarTintColor = UIColor(hex: 0x000000, transparency: 0.9)
        sf.preferredControlTintColor = .white
        
        vc.present(sf, animated: true) { }
    }
    
}
