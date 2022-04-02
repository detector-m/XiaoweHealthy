//
//  XWHTestWebViewBridgeVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/2.
//

import UIKit
import dsBridge

class XWHTestWebViewBridgeVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = DWKWebView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height - 25))
        view.addSubview(webView)
        
        webView.addJavascriptObject(XWHJsApiTest(), namespace: "swift")
        
        // load test.html
        let path = Bundle.main.bundlePath
        let baseUrl = URL(fileURLWithPath: path)
        guard let htmlPath = Bundle.main.path(forResource: "XWHTestWebViewBridge", ofType: "html") else { return }
//        let htmlContent = String(contentsOf: htmlPath, encoding: .utf8)
        
        guard let htmlContent = try? String(contentsOfFile: htmlPath, encoding: .utf8) else { return }
        webView.loadHTMLString(htmlContent, baseURL: baseUrl)
        
//        NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//        [dwebview loadHTMLString:htmlContent baseURL:baseURL];
    }

}
