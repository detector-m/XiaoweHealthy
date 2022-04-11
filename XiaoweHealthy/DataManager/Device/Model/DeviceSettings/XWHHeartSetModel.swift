//
//  XWHHeartSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 心率设置模型
class XWHHeartSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "heart_set_model"
    }
    
    /// 总开关
    var isOn = false

}
