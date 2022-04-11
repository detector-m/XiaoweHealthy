//
//  XWHUserModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation
import HandyJSON
import GRDB

enum XWHUserGenderType: Int {
    
    case none = -1
    case female = 0
    case male
    
}

struct XWHUserModel: Codable, FetchableRecord, TableRecord, PersistableRecord, HandyJSON, CustomDebugStringConvertible {
    
    public enum Columns: String, ColumnExpression {
        case mobile, nickname, avatar, gender, height, weight, birthday, raiseWristLightDuration, goal
    }
    
    // 手机号码
    var mobile = ""
    
    // 昵称
    var nickname = ""
    
    // 头像
    var avatar = ""
    
    // 性别 0 女 1 男
    var gender: Int = 1
    
    var genderType: XWHUserGenderType {
        return XWHUserGenderType(rawValue: gender) ?? .none
    }
    
    // 身高 cm
    var height: Int = 170
    
    // 体重
    var weight: Int = 60
    
    // 生日 格式yyyy-MM-dd
    var birthday: String = "1990-01-01"
    
    // 年龄
    var age: Int {
        let cDate = Date()
        guard let bDate = birthday.date(withFormat: "yyyy-MM-dd") else {
            return 18
        }
    
        return cDate.year - bDate.year
    }
    
    // 抬腕亮屏的时间 5 - 60s
    var raiseWristLightDuration = 5
    
    // 运动目标
    var goal = 8000
    
    static var databaseTableName: String {
        return "user_model"
    }
    
    var debugDescription: String {
        return "gender = \(gender), height = \(height), height = \(weight), birthday = \(birthday), goal"
    }
    
//    func toDic() -> [String: Any] {
//        var cParam = [String: Any]()
//        cParam["gender"] = gender
//        cParam["height"] = height
//        cParam["weight"] = weight
//        cParam["birthday"] = birthday
//        
//        return cParam
//    }
    
}
