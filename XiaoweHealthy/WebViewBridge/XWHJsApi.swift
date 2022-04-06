//
//  XWHJsApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation


class XWHJsApi {
    
    @objc func testSyn( _ arg: String) -> String {
        return String(format:"%@[Sync call:%@]", arg, "Test XWH")
    }
    
    @objc func testAsyn( _ arg: String, handler: XWHTestJSCallback) {
        handler(String(format:"%@[Async call:%@]", arg, "Hello XWH"), true)
    }
    
}
