//
//  UserProfileView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//
import SwiftUI
import LeanCloud

struct UserProfileView: View {
    @State private var currentUser: LCUser? = AuthService.shared.currentUser()
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = currentUser {
                    Text("欢迎, \(user.username?.value ?? "匿名用户")")
                        .font(.title)
                    
                    // 显示扩展信息，后续可扩展头像、昵称编辑等
                    Button(action: {
                        logout()
                    }) {
                        Text("退出登录")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    Text("未登录")
                        .font(.title)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("个人中心", displayMode: .inline)
            .navigationBarItems(trailing: Button("关闭") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func logout() {
        AuthService.shared.logout { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    currentUser = nil
                case .failure(let error):
                    errorMessage = "退出失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
