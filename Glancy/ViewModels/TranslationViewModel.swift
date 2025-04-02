
//
//  TranslationViewModel.swift.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/4/2.
//

import Foundation

class TranslationViewModel: ObservableObject {
    @Published var fullResponse: DeepSeekTranslationResponse?
    @Published var displayText: String = ""
    @Published var errorMessage: String?
    
    /// 用户选中的语言，比如 ["en", "zh"]
    @Published var selectedLanguages: [String] = ["en", "zh"]
    
    /// 解析并显示
    func handleDeepSeekJson(_ jsonString: String) {
        do {
            let parsed = try DeepSeekParser.parse(jsonString: jsonString)
            fullResponse = parsed
            
            // 默认先展示所有
            displayText = DeepSeekParser.toDisplayString(response: parsed)
        } catch {
            errorMessage = "解析失败: \(error.localizedDescription)"
        }
    }
    
    /// 根据 selectedLanguages 过滤并更新 displayText
    func updateDisplayForSelectedLanguages() {
        guard let full = fullResponse else { return }
        
        // 调用 filterResponse
        let filtered = DeepSeekParser.filterResponse(original: full, selectedLanguages: selectedLanguages)
        
        // 只展示选中的语言
        displayText = DeepSeekParser.toDisplayString(response: filtered)
    }
}
