//
//  LoginView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//

import SwiftUI
import LeanCloud

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(isRegistering ? "注册" : "登录")
                    .font(.largeTitle)
                    .bold()
                
                TextField("用户名", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("密码", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if isRegistering {
                        register()
                    } else {
                        login()
                    }
                }) {
                    Text(isRegistering ? "注册" : "登录")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isRegistering.toggle()
                    errorMessage = nil
                }) {
                    Text(isRegistering ? "已有账号？点击登录" : "没有账号？点击注册")
                        .font(.footnote)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button("关闭") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func login() {
        AuthService.shared.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("登录成功: \(user.username?.value ?? "")")
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = "登录失败: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func register() {
        AuthService.shared.register(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("注册成功: \(user.username?.value ?? "")")
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = "注册失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
