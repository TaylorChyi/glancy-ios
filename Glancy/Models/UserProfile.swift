//
//  UserProfile.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//
import Foundation
import LeanCloud

/// 用户自定义资料，存储额外的用户信息，如偏好、头像、昵称等
class UserProfile: LCObject {
    /// 绑定的 LeanCloud 用户（外键关联 LCUser）
    @objc dynamic var user: LCUser?
    
    /// 用户偏好的语言代码数组，例如 ["en", "zh"]
    @objc dynamic var languages: [String]?
    
    /// 用户头像 URL
    @objc dynamic var avatarUrl: String?
    
    /// 用户昵称
    @objc dynamic var nickname: String?
    
    override class func objectClassName() -> String {
        return "UserProfile"
    }
}
