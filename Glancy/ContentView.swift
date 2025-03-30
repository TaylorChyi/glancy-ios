//
//  ContentView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DictionaryViewModel()
    @State private var showSettings = false

    private var availableLanguages: [Language] {
        let codes = LanguagePreferenceManager.shared.load()
        return Language.allLanguages.filter { codes.contains($0.code) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // 语言按钮（可切换开关）
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(availableLanguages) { lang in
                            Text("\(lang.flag) \(lang.name)")
                                .padding(8)
                                .background(viewModel.selectedLanguages.contains(lang.code) ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .onTapGesture {
                                    viewModel.toggleLanguage(lang.code)
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }

                Divider()

                // 查询结果展示区
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                            .padding()
                    } else if !viewModel.resultText.isEmpty {
                        Text(viewModel.resultText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Spacer()
                    }
                }

                Divider()

                // 底部输入栏 + 搜索按钮
                HStack(spacing: 8) {
                    TextField("请输入单词", text: $viewModel.inputWord)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)

                    Button(action: {
                        viewModel.queryWord()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemBackground).ignoresSafeArea(.keyboard, edges: .bottom))
            }
            .toolbar {
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gear")
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationView {
                    LanguageSettingView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
