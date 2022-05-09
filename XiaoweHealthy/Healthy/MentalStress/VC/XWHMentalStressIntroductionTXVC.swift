//
//  XWHMentalStressIntroductionTXVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit
import SwiftRichString

class XWHMentalStressIntroductionTXVC: XWHTextBaseVC {

    override var titleText: String {
        R.string.xwhHealthyText.压力()
    }
    
    private var legend1: String {
        return "legend1"
    }
    
    private var legend2: String {
        return "legend2"
    }
    
    private var legend3: String {
        return "legend3"
    }
    
    private var legend4: String {
        return "legend4"
    }
    
    lazy var legendSize = CGSize(width: 10, height: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupStyle.imageProvider = { [unowned self] (imageName, attributes) in
            if imageName == self.legend1 {
                return UIImage(color: UIColor(hex: 0x49CE64)!, size: legendSize).withRoundedCorners(radius: 4)
            }
            
            if imageName == self.legend2 {
                return UIImage(color: UIColor(hex: 0x76D4EA)!, size: legendSize).withRoundedCorners(radius: 4)
            }
            
            if imageName == self.legend3 {
                return UIImage(color: UIColor(hex: 0xF0B36D)!, size: legendSize).withRoundedCorners(radius: 4)
            }
            
            if imageName == self.legend4 {
                return UIImage(color: UIColor(hex: 0xED7135)!, size: legendSize).withRoundedCorners(radius: 4)
            }
            
            return nil
        }
        
        let text = R.string.xwhHealthyText.bold什么是压力Bold压力在心理学上指精神上束缚和紧张的感受压力的来源是外界刺激如任务和挑战等适当的压力有助于提高人的潜能和效率过度的压力则会令人身心受到折磨并影响长期健康设备监测的压力特指精神压力不包括因高强度运动带来的身体压力压力状态受自主神经系统控制其中交感神经活跃程度的提高会提高压力水平副交感神经活跃程度的提高会降低压力水平自主神经系统的状态可通过心率变异性反映因此通过心率变异性可以帮助我们了解压力水平并引导个体自身的压力调节ImgNamedLegend1放松129ImgNamedLegend2正常3059ImgNamedLegend3中等6079ImgNamedLegend4偏高80100注意处于运动状态或佩戴部位活动频繁时高分辨率心率数据不可用无法准确评估压力为帮助您准确检测日常压力我们会选取您在长时间静止情况下自动测量()
        
        textView.attributedText = text.set(style: groupStyle)
    }

}
