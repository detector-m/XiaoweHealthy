//
//  XWHTextBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import UIKit
import SwiftRichString

class XWHTextBaseVC: XWHBaseVC {
    
    lazy var textView = UITextView()
    
    var titleText: String {
        return ""
    }
    
    lazy var normal = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 14)
        $0.color = fontDarkColor
    }
    lazy var bold = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 22, weight: .bold)
        $0.color = fontDarkColor
    }
    lazy var groupStyle = StyleXML(base: normal, ["bold": bold])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        largeTitleView.titleLb.text = titleText
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        textView.delegate = self
        textView.backgroundColor = bgColor
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.contentInsetAdjustmentBehavior = .never
        textView.isEditable = false
        
        textView.textColor = fontDarkColor
        textView.font = XWHFont.harmonyOSSans(ofSize: 14)
                
        view.addSubview(textView)
        
        setLargeTitleMode()
    }
    
    override func setLargeTitleMode() {
        isUseLargeTitleMode = true
        
        // 大标题方式2
        setLargeTitleModeSecond()
    }
    
    /// 设置第二种方式
    final func setLargeTitleModeSecond() {
        textView.addSubview(largeTitleView)
        setTopInsetForLargeTitle(in: textView)
    }
    
    override func setNavigationBarWithLargeTitle() {
        super.setNavigationBarWithLargeTitle()
        
        navigationItem.title = titleText
    }
    
    
    override func resetNavigationBarWithoutLargeTitle() {
        super.resetNavigationBarWithoutLargeTitle()
        
        navigationItem.title = nil
    }
    
    override func relayoutSubViews() {
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.bottom.equalToSuperview()
        }
        
        largeTitleView.button.isHidden = true
        relayoutLargeTitle()
        largeTitleView.relayout(leftRightInset: 28)
    }
    
    override func relayoutLargeTitle() {
        relayoutLargeTitleSecond()
    }
    
    final func relayoutLargeTitleSecond() {
        largeTitleView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(largeTitleWidth)
            make.top.equalToSuperview().inset(-largeTitleHeight)
            make.height.equalTo(largeTitleHeight)
        }
    }

}

@objc extension XWHTextBaseVC: UITextViewDelegate {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}
