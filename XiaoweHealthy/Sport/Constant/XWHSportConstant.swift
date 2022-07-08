//
//  XWHSportConstant.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import Foundation


extension XWHSportType {
    
    var name: String {
        switch self {
        case .none:
            return ""
            
        case .run:
            return R.string.xwhSportText.跑步()
            
        case .walk:
            return R.string.xwhSportText.步行()
            
        case .ride:
            return R.string.xwhSportText.骑行()
            
        case .climb:
            return R.string.xwhSportText.爬山()
            
        case .other:
            return R.string.xwhSportText.其他()
        }
    }
    
}
