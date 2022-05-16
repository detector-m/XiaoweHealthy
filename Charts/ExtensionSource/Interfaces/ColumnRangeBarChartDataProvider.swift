//
//  ColumnRangeBarChartDataProvider.swift
//  Charts
//
//  Created by Riven on 2022/5/16.
//

import UIKit

@objc
public protocol ColumnRangeBarChartDataProvider: BarLineScatterCandleBubbleChartDataProvider {
    var columnRangeBarData: ColumnRangeBarChartData? { get }
}
