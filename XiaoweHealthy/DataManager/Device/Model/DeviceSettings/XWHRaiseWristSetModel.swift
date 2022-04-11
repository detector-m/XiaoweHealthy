//
//  XWHRaiseWristSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB



// MARK: - 抬腕亮屏设置模型
class XWHRaiseWristSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "raise_wrist_set_model"
    }
    
    /// 总开关
    var isOn = false

}
