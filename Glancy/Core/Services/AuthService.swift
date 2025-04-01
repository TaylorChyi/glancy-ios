//
//  AuthService.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//
import Foundation
import LeanCloud

class AuthService {
    static let shared = AuthService()
    
    // 登录接口
    func login(username: String, password: String, completion: @escaping (Result<LCUser, Error>) -> Void) {
        LCUser.logIn(username: username, password: password) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 手机验证码登录（自动注册或登录）
    func loginOrRegisterByPhoneCode(phoneNumber: String, code: String, completion: @escaping (Result<LCUser, Error>) -> Void) {
        
    }
    
    // 注册接口（用户名注册，邮箱可选）
    func register(username: String, password: String, email: String? = nil, completion: @escaping (Result<LCUser, Error>) -> Void) {
        let user = LCUser()
        try? user.set("username", value: username)
        try? user.set("password", value: password)
        try? user.set("email", value: email)
        user.signUp { result in
            switch result {
            case .success:
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 登出接口
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        LCUser.logOut()
        completion(.success(()))
    }
    
    // 当前用户
    func currentUser() -> LCUser? {
        return LCApplication.default.currentUser
    }
    
    /// 请求短信验证码
    func requestSMSCode(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    /// 发送邮箱验证码 (LeanCloud 并无直接 "requestEmailVerificationCode" 接口，需自定义)
    /// 这里仅示例，真实场景需要你自己在云引擎或后端实现发送邮件逻辑
    func requestEmailCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
        
    /// 验证邮箱验证码进行注册或登录
    func loginOrRegisterByEmailCode(email: String, code: String, completion: @escaping (Result<LCUser, Error>) -> Void) {
        
    }
}
