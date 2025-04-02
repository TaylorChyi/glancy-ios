//
//  DeepSeekParser.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/4/2.
//

import Foundation

struct ParsedWordDefinition {
    let word: String
    let definition: String
}

class DeepSeekParser {
    
    /// 将返回的 JSON 字符串解析为 DeepSeekTranslationResponse 模型
    /// - Parameter jsonString: 从 DeepSeek 返回的 JSON 字符串
    /// - Returns: 解析成功则返回 DeepSeekTranslationResponse，失败会抛出异常
    static func parse(jsonString: String) throws -> DeepSeekTranslationResponse {
        guard let data = jsonString.data(using: .utf8) else {
            throw NSError(domain: "DeepSeekParserError", code: -1, userInfo: [NSLocalizedDescriptionKey : "无效的 JSON 字符串"])
        }
        return try JSONDecoder().decode(DeepSeekTranslationResponse.self, from: data)
    }
    
    /// 过滤出用户所选语言的 key-value 对
    /// - Parameters:
    ///   - original: 解析出的整体数据
    ///   - selectedLanguages: 用户选择的语言代码（例如 ["en", "zh"]）
    /// - Returns: 一个更精简的结构，仅包含所选语言的翻译与例句
    static func filterResponse(
        original: DeepSeekTranslationResponse,
        selectedLanguages: [String]
    ) -> DeepSeekTranslationResponse {
        
        // 过滤 translations
        let filteredTranslations = original.translations.filter { key, _ in
            selectedLanguages.contains(key)
        }
        
        // 过滤 examples
        let filteredExamples = original.examples.filter { key, _ in
            selectedLanguages.contains(key)
        }
        
        // 用过滤后的字典生成新的结构
        let filtered = DeepSeekTranslationResponse(
            word: original.word,
            translations: filteredTranslations,
            examples: filteredExamples
        )
        
        return filtered
    }
    
    /// 将 DeepSeekTranslationResponse 转换为可读字符串，用于简单展示
    /// - Parameter response: DeepSeekTranslationResponse
    /// - Returns: 多语言的翻译 + 例句拼接
    static func toDisplayString(response: DeepSeekTranslationResponse) -> String {
        // 按 translations 的 key 遍历
        var result = "【\(response.word)】\n"
        
        // 根据 translations 的语言，去 examples 里找对应的例句
        for (langCode, translation) in response.translations {
            // 如果 examples 里没有这个 langCode，就给一个空值
            let example = response.examples[langCode] ?? ""
            result += "\n[\(langCode)]\n翻译：\(translation)\n例句：\(example)\n"
        }
        
        return result
    }
}
