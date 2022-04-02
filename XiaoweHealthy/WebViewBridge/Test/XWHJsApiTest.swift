//
//  XWHJsApiTest.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/2.
//

import UIKit

typealias XWHTestJSCallback = (String, Bool)->Void


class XWHJsApiTest: NSObject {

    @objc func testSyn( _ arg: String) -> String {
        return String(format:"%@[Swift sync call:%@]", arg, "test")
    }
    
    @objc func testAsyn( _ arg: String, handler: XWHTestJSCallback) {
        handler(String(format:"%@[Swift async call:%@]", arg, "test"), true)
    }
    
}
