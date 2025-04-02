import SwiftUI

// 如果你需要监听通知，这里可拓展一个通知名
extension Notification.Name {
    static let languagePreferenceUpdated = Notification.Name("languagePreferenceUpdated")
}

struct LanguageBarView: View {
    @ObservedObject var viewModel: DictionaryViewModel
    @State private var refreshLangID = UUID()
    
    /// 计算属性：当前用户可用语言列表
    private var availableLanguages: [Language] {
        let codes = LanguagePreferenceManager.shared.load()
        return Language.allLanguages.filter { codes.contains($0.code) }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(availableLanguages) { lang in
                    Text("\(lang.flag) \(lang.name)")
                        .padding(8)
                        .background(
                            viewModel.selectedLanguages.contains(lang.code)
                            ? Color.blue.opacity(0.3)
                            : Color.gray.opacity(0.2)
                        )
                        .cornerRadius(8)
                        .onTapGesture {
                            viewModel.toggleLanguage(lang.code)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .id(refreshLangID)
        // 当收到通知时，只刷新本子视图
        .onReceive(NotificationCenter.default.publisher(for: .languagePreferenceUpdated)) { _ in
            refreshLangID = UUID()
        }
    }
}
