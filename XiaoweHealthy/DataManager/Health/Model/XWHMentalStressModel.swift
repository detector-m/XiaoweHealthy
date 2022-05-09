//
//  XWHMentalStressModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit


/// 精神压力模型
class XWHMentalStressModel: XWHHeartModel {
    
    class override var databaseTableName: String {
        "mental_stress_model"
    }
    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            srId <-- "id"
        
        mapper <<<
            time <-- "collectTime"
        mapper <<<
            value <-- "pressureVal"
        
        mapper <<<
            identifier <-- "deviceName"
        
//        mapper >>> identifier
    }


}
