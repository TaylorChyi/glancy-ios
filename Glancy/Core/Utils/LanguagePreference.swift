import SwiftUI

class LanguagePreference: ObservableObject {
    static let shared = LanguagePreference()

    // 以 code: .en 来初始化，而不是字符串
    @Published private(set) var selectedLanguages: [Language] = [
        Language(code: .en, name: "English", flag: "🇬🇧")
    ]

    private let maxSelection = 3
    private let storageKey = "selectedLanguages"

    private init() {
        load()
    }

    // 通过比较 code 判断是否选中
    func isSelected(_ language: Language) -> Bool {
        selectedLanguages.contains(where: { $0.code == language.code })
    }

    // 切换语言的选中状态
    func toggle(_ language: Language) {
        if isSelected(language) {
            // 移除时同样比较 code
            selectedLanguages.removeAll(where: { $0.code == language.code })
        } else {
            guard selectedLanguages.count < maxSelection else { return }
            selectedLanguages.append(language)
        }
        save()
    }

    // 持久化时，将 code.rawValue 存储到 UserDefaults
    func save() {
        let codes = selectedLanguages.map { $0.code.rawValue }
        UserDefaults.standard.set(codes, forKey: storageKey)
    }

    // 加载时，从 allLanguages 找到匹配 code 的 Language 实例
    private func load() {
        if let codes = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            selectedLanguages = codes.compactMap { codeString in
                Language.allLanguages.first { $0.code.rawValue == codeString }
            }
        }
    }
}
