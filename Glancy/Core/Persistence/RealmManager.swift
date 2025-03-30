//
//  RealmManager.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/27.
//
import Foundation

import RealmSwift

class WordRecord: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var word: String
    @Persisted var date: Date = Date()
    @Persisted var isFavorite: Bool = false
}

class RealmManager {
    static let shared = RealmManager()
    private let realm = try! Realm()
    
    func save(_ record: WordRecord) {
        try! realm.write {
            realm.add(record)
        }
    }
    
    func fetchAll() -> [WordRecord] {
        return Array(realm.objects(WordRecord.self))
    }
}
