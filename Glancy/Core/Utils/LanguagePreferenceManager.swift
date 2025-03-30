//
//  LanguagePreferenceManager.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation

class LanguagePreferenceManager {
    static let shared = LanguagePreferenceManager()
    private let key = "PreferredLanguages"

    func save(_ codes: [LanguageCode]) {
        let rawValues = codes.map { $0.rawValue }
        UserDefaults.standard.set(rawValues, forKey: key)
    }

    func load() -> [LanguageCode] {
        let rawValues = UserDefaults.standard.stringArray(forKey: key) ?? ["en"]
        return rawValues.compactMap { LanguageCode(rawValue: $0) }
    }
}
