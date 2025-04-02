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
    
    // 全部可选语言列表
    let allLanguages = ["en", "ko", "zh", "ja", "fr", "de"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LanguageBarView(viewModel: viewModel)
                
                // 查询结果展示区
                ScrollView {
                    // 提示 Loading or Error
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                    } else if let err = viewModel.errorMessage {
                        Text("错误：\(err)")
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink(
                        destination: WordDetailView(
                            response: DeepSeekTranslationResponse.testData,
                            selectedLanguages: ["en"]
                        )
                    ) {
                        Text("查看详情")
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
                    // 在设置界面保存时，发送 languagePreferenceUpdated 通知
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
