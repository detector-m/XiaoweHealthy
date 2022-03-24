//
//  XWHUserModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation


struct XWHUserModel: CustomDebugStringConvertible {
    
    // 性别 0 女 1 男
    var gender: Int = 1
    
    // 身高 cm
    var height: Int = 170
    
    // 体重
    var weight: Int = 60
    
    // 生日 格式yyyy-MM-dd
    var birthday: String = "1990-01-01"
    
    var debugDescription: String {
        return "gender = \(gender), height = \(height), height = \(weight), birthday = \(birthday)"
    }
    
    func toDic() -> [String: Any] {
        var cParam = [String: Any]()
        cParam["gender"] = gender
        cParam["height"] = height
        cParam["weight"] = weight
        cParam["birthday"] = birthday
        
        return cParam
    }
    
}
