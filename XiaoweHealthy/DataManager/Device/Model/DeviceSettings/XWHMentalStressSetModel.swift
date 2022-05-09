//
//  XWHMentalStressSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit
import GRDB


// MARK: - 精神压力设置模型
/// 精神压力设置模型
class XWHMentalStressSetModel: XWHDataBaseModel {

    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "mental_stress_set_model"
    }
    
    /// 总开关
    var isOn = false
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
    }
    
}
