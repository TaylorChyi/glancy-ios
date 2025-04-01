//
//  SetPasswordView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//

import SwiftUI
import LeanCloud

struct SetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("设置/修改密码")
                .font(.largeTitle)
                .bold()
            
            SecureField("新密码", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("确认密码", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("保存") {
                setPassword()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
    
    private func setPassword() {
        guard newPassword == confirmPassword else {
            errorMessage = "两次输入的密码不一致"
            return
        }
        guard let user = AuthService.shared.currentUser() else {
            errorMessage = "尚未登录"
            return
        }
        
        // LeanCloud 更新密码
        // 需要注意：若 user 没有旧密码（比如是手机验证码登录创建的账号），可以直接设置
        // 如果 LeanCloud 要求 old_password，可通过 user.updatePassword(...)
        // 这里假设 user 目前没有旧密码
        user.password = LCString(newPassword)
        user.save { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    errorMessage = "密码设置成功"
                    // 关闭页面
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = "设置失败: \(error.localizedDescription)"
                }
            }
        }
    }
}
