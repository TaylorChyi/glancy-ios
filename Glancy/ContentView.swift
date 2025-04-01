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
    @State private var showAuthSheet = false

    // availableLanguages 从设置中确定显示哪些语言按钮
    private var availableLanguages: [Language] {
        let codes = LanguagePreferenceManager.shared.load()
        return Language.allLanguages.filter { codes.contains($0.code) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部语言按钮区域（点击切换实际请求使用的语言）
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
                
                // 历史搜索记录标签区（最新10个搜索词）
                HistoryTagsView { selectedWord in
                    viewModel.inputWord = selectedWord
                    viewModel.queryWord()
                }
                
                // 底部输入栏及搜索按钮（类似聊天输入栏）
                HStack(spacing: 8) {
                    TextField("请输入单词", text: $viewModel.inputWord)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    
                    Button(action: {
                        print("asdfadsfa")
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAuthSheet = true
                    }) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationView {
                    LanguageSettingView()
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                if AuthService.shared.currentUser() == nil {
                    MultiMethodLoginView()
                } else {
                    UserProfileView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
