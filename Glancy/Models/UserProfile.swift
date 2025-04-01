//
//  UserProfile.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//
import Foundation
import LeanCloud

class UserProfile: LCObject {
    // 绑定 LCUser 对象（外键）
    @objc dynamic var user: LCUser?
    
    // 用户偏好语言数组（存储为字符串数组，如 ["en", "zh"]）
    @objc dynamic var languages: [String]?
    
    // 用户昵称
    @objc dynamic var nickname: String?
    
    // 头像 URL
    @objc dynamic var avatarUrl: String?
    
    // 用户等级
    @objc dynamic var level: Int = 1
    
    // 是否会员标识
    @objc dynamic var isMember: Bool = false
    
    // 会员过期时间
    @objc dynamic var memberExpireDate: Date?
    
    override class func objectClassName() -> String {
        return "UserProfile"
    }
}
