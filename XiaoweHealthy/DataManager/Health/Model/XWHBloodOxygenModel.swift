//
//  XWHBloodOxygenModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHBloodOxygenModel: XWHHeartModel {
    
    class override var databaseTableName: String {
        "blood_oxygen_model"
    }
    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            srId <-- "id"
        
        mapper <<<
            time <-- "collectTime"
        mapper <<<
            value <-- "oxygenVal"
        
        mapper <<<
            identifier <-- "deviceName"
        
//        mapper >>> identifier
    }

}
