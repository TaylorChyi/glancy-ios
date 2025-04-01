import SwiftUI
import LeanCloud

enum LoginMode: String, CaseIterable {
    case password = "密码登录"
    case code = "验证码登录"
}

/// 登录凭证类型（仅用于密码登录时区分输入类型）
enum CredentialType: String, CaseIterable {
    case username = "用户名"
    case phone = "手机号"
    case email = "邮箱"
}

enum CodeCredentialType: String, CaseIterable {
    case phone = "手机号"
    case email = "邮箱"  // 注意：邮箱登录时同时需要手机验证
}

struct MultiMethodLoginView: View {
    @State private var loginMode: LoginMode = .code  // 默认验证码登录（首次注册建议走验证码）
    
    // 密码登录时的凭证类型与输入内容
    @State private var credentialType: CredentialType = .username
    @State private var credential = ""
    @State private var password = ""
    
    // 验证码登录时的凭证类型与输入内容
    @State private var codeCredentialType: CodeCredentialType = .phone
    @State private var phoneForCode = ""
    @State private var emailForCode = ""
    @State private var verificationCode = ""
    
    @State private var errorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("登录")
                    .font(.largeTitle)
                    .bold()
                
                // 切换登录模式：密码登录 或 验证码登录
                Picker("登录模式", selection: $loginMode) {
                    ForEach(LoginMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if loginMode == .password {
                    // 密码登录：选择凭证类型（用户名、手机号、邮箱）和输入密码
                    Picker("凭证类型", selection: $credentialType) {
                        ForEach(CredentialType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    TextField("请输入\(credentialType.rawValue)", text: $credential)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(credentialType == .phone ? .phonePad : .default)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                    
                    SecureField("请输入密码", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    // 验证码登录：选择凭证类型（手机号 或 邮箱）
                    Picker("登录方式", selection: $codeCredentialType) {
                        ForEach(CodeCredentialType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    if codeCredentialType == .phone {
                        // 仅手机号模式
                        TextField("请输入手机号", text: $phoneForCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding(.horizontal)
                    } else {
                        // 邮箱模式：要求同时输入邮箱和手机号
                        TextField("请输入邮箱地址", text: $emailForCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                        
                        TextField("请输入绑定的手机号", text: $phoneForCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding(.horizontal)
                    }
                    
                    HStack {
                        TextField("请输入验证码", text: $verificationCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("发送验证码") {
                            sendVerificationCode()
                        }
                        .frame(minWidth: 100)
                    }
                    .padding(.horizontal)
                }
                
                if let msg = errorMessage {
                    Text(msg)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    loginAction()
                }) {
                    Text("登录")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button("关闭") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    // MARK: - 登录操作
    private func loginAction() {
       
    }
    
    // MARK: - 发送验证码
    private func sendVerificationCode() {
        
    }
}
