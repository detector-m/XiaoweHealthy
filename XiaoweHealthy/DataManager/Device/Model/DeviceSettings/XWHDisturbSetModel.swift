//
//  XWHDisturbSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 勿扰设置模型
class XWHDisturbSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "disturb_set_model"
    }
    
    /// 总开关
    var isOn = false

}
