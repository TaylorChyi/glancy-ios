//
//  Language.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation

enum LanguageCode: String, CaseIterable {
    case en, zh, ja, ko, fr, de, pt, es, ar
}

struct Language: Identifiable {
    let id = UUID()
    let code: LanguageCode
    let name: String
    let flag: String

    static let allLanguages: [Language] = [
        Language(code: .en, name: "English", flag: "🇬🇧"),
        Language(code: .zh, name: "中文", flag: "🇨🇳"),
        Language(code: .ja, name: "日本語", flag: "🇯🇵"),
        Language(code: .ko, name: "한국어", flag: "🇰🇷"),
        Language(code: .fr, name: "Français", flag: "🇫🇷"),
        Language(code: .de, name: "Deutsch", flag: "🇩🇪"),
        Language(code: .pt, name: "Português", flag: "🇵🇹"),
        Language(code: .es, name: "Español", flag: "🇪🇸"),
        Language(code: .ar, name: "العربية", flag: "🇸🇦")
    ]
}
