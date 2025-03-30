//
//  SecretsManager.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation

enum SecretsManager {
    static var deepSeekApiKey: String {
        guard let path = Bundle.main.path(forResource: "SecretKeys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["DEEPSEEK_API_KEY"] as? String else {
            fatalError("🔑 DeepSeek API Key not found!")
        }
        return key
    }
}
