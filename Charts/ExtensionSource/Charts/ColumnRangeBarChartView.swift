//
//  ColumnRangeBarChartView.swift
//  Charts
//
//  Created by Riven on 2022/5/16.
//

import UIKit

open class ColumnRangeBarChartView: BarLineChartViewBase, ColumnRangeBarChartDataProvider {

    internal override func initialize() {
        super.initialize()
        
        renderer = ColumnRangeBarChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
        
        self.xAxis.spaceMin = 0.5
        self.xAxis.spaceMax = 0.5
    }

    // MARK: - ColumnRangeBarChartDataProvider

    open var columnRangeBarData: ColumnRangeBarChartData? {
        return _data as? ColumnRangeBarChartData
    }

}
