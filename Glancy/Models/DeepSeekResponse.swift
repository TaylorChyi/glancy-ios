//
//  ChatResponse.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation

struct DeepSeekResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}
