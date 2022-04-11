//
//  XWHBloodOxygenSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 血氧设置模型
class XWHBloodOxygenSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, duration
    }
    
    class override var databaseTableName: String {
        "blood_oxygen_set_model"
    }
    
    /// 总开关
    var isOn = false
    
    /// 间隔时间 分钟
    var duration = 60

}
