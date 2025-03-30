//
//  DictionaryViewModel.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/27.
//

import Foundation
import SwiftUI

class DictionaryViewModel: ObservableObject {
    @Published var inputWord: String = ""
    @Published var resultText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var selectedLanguages: [LanguageCode] = LanguagePreferenceManager.shared.load()

    func toggleLanguage(_ code: LanguageCode) {
        if selectedLanguages.contains(code) {
            if selectedLanguages.count > 1 {
                selectedLanguages.removeAll { $0 == code }
            }
        } else if selectedLanguages.count < 3 {
            selectedLanguages.append(code)
        }
    }

    private let cloudService = CloudDictionaryService()

    func queryWord() {
        guard !inputWord.isEmpty else {
            errorMessage = "请输入单词"
            return
        }

        isLoading = true
        errorMessage = nil
        resultText = ""

        // Step 1: 查询 LeanCloud
        cloudService.fetchDefinition(for: inputWord) { [weak self] cached in
            DispatchQueue.main.async {
                if let cached = cached {
                    self?.resultText = cached.definition
                    self?.isLoading = false
                } else {
                    self?.fetchFromDeepSeek()
                }
            }
        }
    }

    private func fetchFromDeepSeek() {
        DeepSeekService.shared.queryDefinition(for: inputWord, languages: selectedLanguages) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let content):
                    // Step 1: 显示
                    self?.resultText = content
                    
                    // Step 2: 解析并存储
                    let parsed = DeepSeekParser.parse(content: content, for: self?.inputWord ?? "")
                    self?.cloudService.saveDefinition(word: parsed.word, definition: parsed.definition)

                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
