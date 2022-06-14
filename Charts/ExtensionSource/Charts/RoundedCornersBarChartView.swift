//
//  RoundedCornersBarChartView.swift
//  Charts
//
//  Created by Riven on 2022/6/14.
//

import UIKit

open class RoundedCornersBarChartView: BarChartView {

    internal override func initialize() {
        super.initialize()
        
        renderer = RoundedCornersBarChatRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
    }

}
