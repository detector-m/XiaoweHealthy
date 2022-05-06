//
//  XWHSleepIntroductionTXVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHSleepIntroductionTXVC: XWHTextBaseVC {
    
    override var titleText: String {
        R.string.xwhHealthyText.睡眠()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = R.string.xwhHealthyText.bold睡眠总时长Bold理想成年人在79小时睡眠总时长是入睡到出睡过程中深睡浅睡和快速眼动睡眠的时长总和睡眠时长少于理想时长会对体力情绪和认知功能会产生不良影响同时睡眠也不是越多越好长期超过理想睡眠时长会增加中风心脏病糖尿病的发病风险睡眠时长受遗传主观意志生物钟等许多因素影响很难有一个绝对标准美国国家睡眠基金会建议成年人每天睡眠79个小时考虑到个体差异610个小时都属于较合理的范围Bold深睡眠Bold理想20睡眠周期的第三阶段和第四阶段睡眠是深睡的阶段也被称作是黄金睡眠一般占整个睡眠时间的1525深度睡眠使大脑可以得到充分的休息促进人体的新陈代谢消除疲劳还有助于记忆力的提升Bold浅睡眠Bold理想60睡眠周期的第一阶段和第二阶段睡眠被称为浅睡眠一般占整个睡眠时间大约55且不宜超过60在浅睡睡眠阶段人容易被唤醒浅睡睡眠对缓解人疲劳的作用甚微Bold清醒Bold理想总时长20分钟次数2次单次清醒时长不超过10分钟次数在2次以内为正常经常在夜里醒来的人睡眠片段化严重可能导致睡眠稳定性不佳深度睡眠较少Bold如何改善睡眠质量Bold大部分睡眠质量不好的人或多或少都存在不良睡眠习惯如作息不规律缺乏充足的阳光照射缺乏足够的体育运动经常喝咖啡喝酒抽烟等睡眠质量还受心理因素生理因素和环境因素影响如焦虑疲劳卧室的光线噪音温湿度等了解科学的睡眠卫生知识分析与寻找不良睡眠习惯或心理生理环境因素对睡眠质量的影响并及时进行调整可以改善睡眠通过智能穿戴产品可以帮助您获取科学的睡眠质量评估和改善建议本产品非医学设备所提供的睡眠数据和睡眠建议仅供参考()
        
        textView.attributedText = text.set(style: groupStyle)
    }

}
