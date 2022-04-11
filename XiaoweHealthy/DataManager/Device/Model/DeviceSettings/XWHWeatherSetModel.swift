//
//  XWHWeatherSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 天气设置模型
class XWHWeatherSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "weather_set_model"
    }
    
    /// 总开关
    var isOn = false

}
