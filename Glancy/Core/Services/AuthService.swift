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
    
    /// 登录
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
    
    /// 注册
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
    
    /// 登出
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        LCUser.logOut()
        completion(.success(()))
    }
    
    /// 当前用户
    func currentUser() -> LCUser? {
        return LCApplication.default.currentUser
    }
}
