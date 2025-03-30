//
//  DeepSeekParser.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation

struct ParsedWordDefinition {
    let word: String
    let definition: String
}

class DeepSeekParser {
    /// 从 DeepSeek 返回的自然语言中提取结构化数据
    static func parse(content: String, for word: String) -> ParsedWordDefinition {
        // 目前简单处理，直接当作整段定义存储
        return ParsedWordDefinition(word: word, definition: content.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
