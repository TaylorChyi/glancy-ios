import Foundation

class DictionaryViewModel: ObservableObject {
    @Published var inputWord: String = ""
    @Published var resultText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var deepSeekResponse: DeepSeekResponse? // or whatever type it is
    @Published var deepSeekTranslationResponse: DeepSeekTranslationResponse? // or whatever type it is

    // 当前请求使用的语言（由主界面语言按钮控制）
    @Published var selectedLanguages: [LanguageCode] = LanguagePreferenceManager.shared.load()

    private let cloudService = CloudDictionaryService()
    
    func toggleLanguage(_ code: LanguageCode) {
        if selectedLanguages.contains(code) {
            if selectedLanguages.count > 1 {
                selectedLanguages.removeAll { $0 == code }
            }
        } else if selectedLanguages.count < 3 {
            selectedLanguages.append(code)
        }
    }
    
    func queryWord() {
        guard !inputWord.isEmpty else {
            errorMessage = "请输入单词"
            return
        }
        
        // 添加搜索记录（更新或新建）
        SearchHistoryManager.shared.addSearchRecord(word: inputWord)
        
        isLoading = true
        errorMessage = nil
        resultText = ""
        
        // Step 1: 查询 LeanCloud
        cloudService.fetchDefinition(for: inputWord) { [weak self] cached in
            DispatchQueue.main.async {
                if let cached = cached {
                    self?.resultText = cached.definition
                    self?.isLoading = false
                } else {
                    self?.fetchFromDeepSeek()
                }
            }
        }
    }
    
    private func fetchFromDeepSeek() {
        DeepSeekService.shared.queryDefinition(for: inputWord) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let content):
                    self?.resultText = content

                    self?.cloudService.saveDefinition(
                        word: self?.deepSeekTranslationResponse?.word ?? "",
                        definition: self?.deepSeekTranslationResponse?.translations.values.sorted().first ?? ""
                    )
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
