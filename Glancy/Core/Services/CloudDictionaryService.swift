//
//  CloudDictionaryService.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import Foundation
import LeanCloud

struct CloudWordDefinition: Codable {
    let word: String
    let definition: String
}

class CloudDictionaryService {
    static let shared = CloudDictionaryService()
    
    /// 查询词义
    func fetchDefinition(for word: String, completion: @escaping (CloudWordDefinition?) -> Void) {
        let query = LCQuery(className: "WordDefinition")
        query.whereKey("word", .equalTo(word.lowercased()))
        query.getFirst { result in
            switch result {
            case .success(let object):
                if let def = object.get("definition")?.stringValue {
                    let entry = CloudWordDefinition(word: word, definition: def)
                    completion(entry)
                } else {
                    completion(nil)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }

    /// 保存词义
    func saveDefinition(word: String, definition: String) {
        let object = LCObject(className: "WordDefinition")
        try? object.set("word", value: word.lowercased())
        try? object.set("definition", value: definition)
        object.save { result in
            switch result {
            case .success:
                print("✅ 云端保存成功")
            case .failure(let error):
                print("❌ 云端保存失败: \(error)")
            }
        }
    }
}
