//
//  XWHBOIntroductionTXVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import UIKit
import SwiftRichString

class XWHBOIntroductionTXVC: XWHTextBaseVC {
    
    override var titleText: String {
        R.string.xwhHealthyText.血氧饱和度()
    }
    
    private var legend1: String {
        return "legend1"
    }
    
    private var legend2: String {
        return "legend2"
    }
    
    lazy var legendSize = CGSize(width: 10, height: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupStyle.imageProvider = { [unowned self] (imageName, attributes) in
            if imageName == self.legend1 {
                return UIImage(color: UIColor(hex: 0x6CD267)!, size: legendSize).withRoundedCorners(radius: 4)
            }
            
            if imageName == self.legend2 {
                return UIImage(color: UIColor(hex: 0xF0B36D)!, size: legendSize).withRoundedCorners(radius: 4)
            }
            
            return nil
        }
        
        let text = R.string.xwhHealthyText.bold什么是血氧饱和度Bold血氧饱和度Sp02是血液中被氧结合的血红蛋白的容量占全部可结合的血红蛋白容量的百分比即血液中血氧的浓度它是呼吸循环的重要生理参数是身体健康的重要指标之一绝大多数人的血氧水平介于95100之间也有一部分生活正常的人血氧水平低于95受个人身体状态活动海拔某些疾病的影响血氧饱和度会有不同ImgNamedLegned1正常血氧90ImgNamedLegned2低血氧7089()
        
        textView.attributedText = text.set(style: groupStyle)
    }

}
