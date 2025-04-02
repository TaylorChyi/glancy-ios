//
//  DeepSeekTranslationResponse.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/4/2.
//

import Foundation

/// 对应 DeepSeek 返回的 JSON 数据结构
struct DeepSeekTranslationResponse: Codable {
    let word: String
    let translations: [String: String] // "en" -> "stimulus"
    let examples: [String: String]     // "en" -> "The new policy..."
    
    static var testData: DeepSeekTranslationResponse {
            DeepSeekTranslationResponse(
                word: "测试单词",
                translations: [
                    "en": "test",
                    "zh": "测试"
                ],
                examples: [
                    "en": "This is a test.",
                    "zh": "这是一个测试。"
                ]
            )
        }
}
