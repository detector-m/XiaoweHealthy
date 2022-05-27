//
//  XWHMoodIntroductionTXVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit
import SwiftRichString


// FIXME: 需要完善
class XWHMoodIntroductionTXVC: XWHTextBaseVC {
    
    override var titleText: String {
        R.string.xwhHealthyText.情绪()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = R.string.xwhHealthyText.积极当前情绪主积极说明你的情绪状态是愉快和舒适的您可能达到某些期盼的目的或处于相对放松的状态有一定的满足感和幸福感2消极当前情绪主消极说明你的情绪状态是焦虑紧张的也可能是消极颓废的长期消极情绪容易引发身心疾病3平和当前情绪主平和说明你的情绪状态是比较安静平和的比较适合学习有利于身心健康()
        
        textView.attributedText = text.set(style: groupStyle)
    }

}
