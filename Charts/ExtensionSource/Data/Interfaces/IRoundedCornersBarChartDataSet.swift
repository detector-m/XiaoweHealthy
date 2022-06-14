//
//  IRoundedCornersBarChartDataSet.swift
//  Charts
//
//  Created by Riven on 2022/6/14.
//

import UIKit

@objc
public protocol IRoundedCornersBarChartDataSet: IBarChartDataSet {

    /// corners to be rounded
    var roundedCorners: UIRectCorner { get set }
    
}
