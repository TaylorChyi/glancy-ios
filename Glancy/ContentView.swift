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

    // availableLanguages 由设置中允许的语言决定（设置界面只提供可选列表）
    private var availableLanguages: [Language] {
        let codes = LanguagePreferenceManager.shared.load()
        return Language.allLanguages.filter { codes.contains($0.code) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // 语言按钮（点击后切换实际请求使用的语言开关）
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

                // 底部输入栏 + 搜索按钮（仿微信样式）
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
                    LanguageSettingView()
                }
            }
            .sheet(isPresented: $showAuthSheet) {
                // 如果当前未登录，则显示登录界面，否则显示用户个人中心界面
                if AuthService.shared.currentUser() == nil {
                    LoginView()
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
