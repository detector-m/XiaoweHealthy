//
//  XWHActivityIntroductionTXVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/14.
//

import UIKit

class XWHActivityIntroductionTXVC: XWHTextBaseVC {

    override var titleText: String {
        R.string.xwhHealthyText.活动数据()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = R.string.xwhHealthyText.bold步数Bold步数会统计你一天24小时活动产生的总步数包括日常走路跑步和健走等运动产生的步数携带手机或佩戴智能手表产生的所有步数都会被统计根据中国居民膳食指南建议每天8000步有助于身体保持健康每日步数会结合身高体重情况将步数换算为对应的距离和消耗有助于养成健康的生活习惯Bold活动消耗Bold活动消耗会统计你一天24小时活动消耗的能量建议每天活动消耗300千卡结合饮食控制有助于保持身体健康Bold距离Bold统计你走路和各项运动产生的距离公里数()
        
        textView.attributedText = text.set(style: groupStyle)
    }

}
