//
//  WordDetailView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/4/2.
//

import SwiftUI

/// 显示 DeepSeekTranslationResponse 中用户所需语言的翻译与例句
struct WordDetailView: View {
    /// 完整的 DeepSeek 数据
    let response: DeepSeekTranslationResponse
    /// 用户实际选中的语言（如 ["en", "ko", "de"]）
    let selectedLanguages: [String]
    
    // 利用一个 computed property 筛选出需要的结果
    private var filteredResponse: DeepSeekTranslationResponse {
        DeepSeekParser.filterResponse(original: response, selectedLanguages: selectedLanguages)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 顶部显示「word」
            Text("单词：\(filteredResponse.word)")
                .font(.title2)
                .bold()
                .padding(.top, 8)
            
            // 逐个语言展示翻译与例句
            ForEach(filteredResponse.translations.keys.sorted(), id: \.self) { langCode in
                // 取对应的翻译
                let translation = filteredResponse.translations[langCode] ?? ""
                // 取对应的例句
                let example = filteredResponse.examples[langCode] ?? ""
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("语言：\(langCode)")
                        .font(.headline)
                    Text("翻译：\(translation)")
                    if !example.isEmpty {
                        Text("例句：\(example)")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("词语详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}
