//
//  AppPrivacyVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/18.
//

import UIKit
import SwiftRichString

class AppPrivacyVC: UIViewController, UITextViewDelegate {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.type = .axial
        return gradientLayer
    }()
    private lazy var gradientColors: [UIColor] = [UIColor(hex: 0xD5F9E1)!, UIColor(hex: 0xF8F8F8)!]
    
    private lazy var contentView = UIView()
    private lazy var titleLb = UILabel()
    private lazy var textView = UITextView()
    
    private lazy var agreeBtn = UIButton()
    private lazy var rejectBtn = UIButton()
    
    private lazy var normal = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 16)
        $0.color = fontDarkColor
    }
    private lazy var light = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        $0.color = fontDarkColor.withAlphaComponent(0.4)
    }
    
    private lazy var link1 = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
        $0.linkURL = URL(string: "link1")
    }
    
    private lazy var link2 = Style {
        $0.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
        $0.linkURL = URL(string: "link2")
    }
        
    private var privacyString1: String {
        "《小维健康用户协议》"
    }
    private var privacyString2: String {
        "《小维健康隐私政策》"
    }
    private var topText: String {
        return "在你使用小维健康APP前，请认真阅读并了解\(privacyString1)和\(privacyString2)，我们将按照政策和协议内容为您提供服务，我们会收集您的位置等信息，特向您说明如下：\n\n"
    }
    
    private var bottomText: String {
        "1：使用运动健康功能时，我们需要你登录小维健康账号，并且可能会申请你的手机蓝牙，健康等权限。\n\n2：我们将根据《隐私政策》收集对应功能所需的个人信息，运动和健康数据包含的敏感个人信息，我们将获取您的同意\n\n3:您可以修改、查询、您的个人信息\n\n4:为经过您的同意，我们不会从第三方处获取、共享或提供您的信息。"
    }
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.makeTransparent()
        
        addSubViews()
        
        var a1 = topText.set(style: normal)
        var sRange = (topText as NSString).range(of: privacyString1)
        a1 = topText.set(style: link1, range: sRange)
        sRange = (topText as NSString).range(of: privacyString2)
        a1 = a1.set(style: link2, range: sRange)
        let a2 = bottomText.set(style: light)
        textView.attributedText = a1 + a2
        
        textView.linkTextAttributes = [.foregroundColor: btnBgColor]
    }
    
    private func addSubViews() {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(contentView)
        
        contentView.addSubview(titleLb)
        contentView.addSubview(textView)
        view.addSubview(agreeBtn)
        view.addSubview(rejectBtn)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        titleLb.textColor = fontDarkColor
        titleLb.textAlignment = .center
        
        titleLb.text = "欢迎使用小维健康APP"
        
        agreeBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        agreeBtn.setTitleColor(.white, for: .normal)
        agreeBtn.addTarget(self, action: #selector(clickAgreeBtn), for: .touchUpInside)
        agreeBtn.layer.cornerRadius = 24
        agreeBtn.layer.backgroundColor = btnBgColor.cgColor
        
        rejectBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        rejectBtn.setTitleColor(fontDarkColor, for: .normal)
        rejectBtn.addTarget(self, action: #selector(clickRejectBtn), for: .touchUpInside)
        
        agreeBtn.setTitle("同意", for: .normal)
        rejectBtn.setTitle("拒绝", for: .normal)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
        
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        relayoutSubViews()
    }
    
    private func relayoutSubViews() {
        var contentHeight: CGFloat = 471
        if UIScreen.main.bounds.height < 812 {
            contentHeight -= 50
        }
            
        contentView.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 16, width: view.width - 32, height: contentHeight)
        
        var yOffset = contentView.y + contentView.height + 38

        let xOffset = (view.width - 244) / 2
        agreeBtn.frame = CGRect(x: xOffset, y: yOffset, width: 244, height: 48)
        
        yOffset += 48
        rejectBtn.frame = CGRect(x: agreeBtn.x, y: yOffset, width: agreeBtn.width, height: 48)

        titleLb.frame = CGRect(x: 20, y: 20, width: contentView.width - 40, height: 27)
        yOffset = titleLb.y + titleLb.height + 23
        textView.frame = CGRect(x: titleLb.x, y: titleLb.y + titleLb.height + 23, width: titleLb.width, height: contentView.height - 20 - yOffset)
    }
    
    @objc private func clickAgreeBtn() {
        AppPrivacy.isShow = false
        completion?()
    }
    
    @objc private func clickRejectBtn() {
        exit(0)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
        if url.absoluteString == "link1" {
            XWHSafari.gotoPrivacyProtocol(at: self)
            return false
        }
        
        if url.absoluteString == "link2" {
            XWHSafari.gotoUserProtocol(at: self)
            return false
        }
        
        return true
    }

}
