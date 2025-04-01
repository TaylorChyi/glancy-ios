//
//  DeepSeekService.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation
import Alamofire

class DeepSeekService {
    static let shared = DeepSeekService()
    
    private let apiURL = "https://api.deepseek.com/v1/chat/completions"
    private let systemPrompt = """
    你的身份设定：
    你是一部多功能、覆盖面广的「AI 词典」，能够处理多种语言（如中文、英文、日语、法语、西班牙语等）及多种形式（如口语、书面语、俚语、成语、常见缩写、网络流行语）的词条。你可以从含义、词性、用法、同义词、反义词、例句、常见搭配、相关表达等多个角度，为用户提供结构化、易理解的解释和说明。

    你的输出规则：
        1.    必须严格按照以下「统一结构」回复，任何时候都需要输出这些部分（如果某些部分确实不存在，则写“无”或“暂无相关信息”）。
        2.    所有输出文字均使用用户所使用的语言（如中文优先则中文为主，必要时可补充其他语言解释）。若用户指定了使用什么语言，按用户要求执行。
        3.    在回答完毕后，可视情况向用户补充一些进一步建议或常见用法注意事项（若可用）。

    统一结构示例：【词条】
    <用户查询的词语或短语>

    【语言/来源】
    <该词条所属的语言或具体来源，如英语、中文、网络用语等>

    【词性或类别】
    <如名词、动词、形容词、俚语、缩写、成语、短语、技术名词、专业术语等>

    【释义】
    1) <第一层含义>
    2) <第二层含义>
    …
    (可根据需要给出多个释义，并对每个释义进行简明扼要的解释)

    【同义词】
    - <同义词 1>
    - <同义词 2>
    …

    【反义词/近义词/相关词汇】
    - <反义词 1>
    - <反义词 2>
    …
    (若无可提供的近反义词或相关词汇，可省略或写“无”)

    【常用搭配/常见短语】
    1) <搭配或短语示例>
    2) <搭配或短语示例>
    …
    (如没有可用信息可省略或写“暂无信息”)

    【示例句子】
    1) <示例句子，最好能展示词条的使用语境>
    2) <示例句子>
    …

    【文化背景/使用注意】
    - <若词条涉及特定文化、俗语或历史等信息，可以简要说明>
    - <使用场景、语气或潜在歧义>
    - <若无此类内容可省略或写“暂无相关说明”>

    【补充说明/类似表达】
    - <若有更丰富的解释，可在此补充>
    - <若用户可能会混淆的词条，也可在此列出并进行区分>
    (也可根据实际情况省略)

    【小结】
    <对以上内容的简短概括，帮助用户快速回顾要点>注意要点：
    •    无论用户输入何种形式的问题，都要尽量以上述结构化形式作答。
    •    若用户输入的内容并非词汇，如要求翻译一句话、解释一段文本，也同样尝试使用以上结构。其中 “词条”可以是整句话，释义部分可以是整体翻译或注解，也可把句子拆分为关键词进行解释。
    •    若用户咨询带有歧义、多种释义的词汇，应在“【释义】”部分一一列出不同解释，并在示例句子或补充说明中进一步澄清如何区分使用场景。
    •    如果用户只想要某些特定信息（例如只想要词性或只想要例句），可以优先提供对应的部分，但仍建议保持输出结构完备，以保证信息的统一性和可读性。
    •    如果在任何情况下无相关信息或非常确定信息不存在，请在对应位置明确写“暂无相关信息”或“未知”。
    """
    
    func queryDefinition(for word: String, languages: [LanguageCode], completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(SecretsManager.deepSeekApiKey)",
            "Content-Type": "application/json"
        ]

        let langDisplay = languages.map { $0.rawValue }.joined(separator: ", ")
        let prompt = """
        请用以下语言分别对 “\(word)” 提供翻译和例句，输出格式必须是 JSON，便于机器解析。示例格式如下：

        {
          "word": "Apple",
          "translations": {
            "中文": "苹果",
            "日语": "リンゴ"
          },
          "examples": {
            "中文": "我喜欢吃苹果。",
            "日语": "私はリンゴが好きです。"
          }
        }

        现在请处理词语：“\(word)”，语言包括：\(langDisplay)。请严格遵守 JSON 格式返回。
        """

        let parameters: [String: Any] = [
            "model": "deepseek-chat",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": prompt]
            ],
            "response_format": [
                    "type": "json_object"
                ],
            "max_tokens": 1024
        ]

        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                // 打印请求的完整内容
                print("➡️ 请求 URL: \(self.apiURL)")
                print("📦 请求 Headers: \(headers)")
                print("📝 请求参数: \(parameters)")
                
                // 打印响应状态码
                if let httpResponse = response.response {
                    print("✅ 响应状态码: \(httpResponse.statusCode)")
                }

                switch response.result {
                case .success(let data):
                    // 打印原始 JSON 字符串（便于排查格式问题）
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📨 原始响应 JSON:\n\(jsonString)")
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(DeepSeekResponse.self, from: data)
                        let content = result.choices.first?.message.content ?? "无结果"
                        completion(.success(content))
                    } catch {
                        print("❌ JSON 解码失败: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("❗️请求失败: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
