//
//  XWHHeartIntroductionTXVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import UIKit
import SwiftRichString


/// 心率介绍
class XWHHeartIntroductionTXVC: XWHTextBaseVC {
    
    override var titleText: String {
        R.string.xwhHealthyText.心率()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let text = R.string.xwhHealthyText.bold静息心率Bold该心率的范围内94次分钟通常是在清醒不活动的状态下每分钟心跳的次数Bold减压心率Bold该心率的范围内95112次分钟属于低强度运动有提升新陈代谢和情绪健康的好处在这个区间锻炼可以降低胆固醇减轻精神压力改善血压状态Bold燃脂心率Bold该心率的范围内113131次分钟属于低等到中等强度运动比起静息状态下运动会燃烧更多的热量和脂肪在此心率下运动者可能会开始出汗Bold心肺心率Bold该心率的范围内132150次分钟能够提升耐受力也就是长时间运动而不疲劳的能力心肺锻炼可以显著加强健身效果其可以增加线粒体密度和提高脂肪的利用率从而使每分钟的运动消耗更多的热量Bold无氧心率Bold该心率的范围内151169次分钟此状态被认为是运动员或竞技选手的专属但实际上对所有人都适用此状态常被命名为临界状态因为它更适合那些希望进一步提升运动速度的人群这些人常常混合燃脂状态和心肺锻炼的运动强度增加一些变化改善有氧代谢能力随着肌肉对乳酸的耐受力的进一步增强耐力也会随之提升适当的做无氧运动可以增强体质建议单次无氧运动时间控制在5分钟以内若长时间过度做无氧运动反而会给身体器官带来损伤的风险Bold极限心率Bold该心率的范围内169次分钟达到近乎全力以赴的训练强度只能持续很短的时间跨度对于竞技选手无氧训练的运动可以持续2030分钟5公里竞速而对于大多数受训不充分的人群无氧训练运动会带来一个非常高的代谢应激负荷通常只能维持25分钟如果心率达到极限状态一定要多加注意身体变化情况很有可能出现身体不适()
        
        textView.attributedText = text.set(style: groupStyle)
    }
    
}
