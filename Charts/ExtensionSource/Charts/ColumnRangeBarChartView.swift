//
//  ColumnRangeBarChartView.swift
//  Charts
//
//  Created by Riven on 2022/5/16.
//

import UIKit

open class ColumnRangeBarChartView: CandleStickChartView {

    internal override func initialize() {
        super.initialize()
        
        renderer = ColumnRangeBarChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
    }

}
