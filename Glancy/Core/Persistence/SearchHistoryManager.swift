import Foundation
import RealmSwift

// 添加通知扩展
extension Notification.Name {
    static let searchHistoryUpdated = Notification.Name("searchHistoryUpdated")
}

// 管理搜索记录的增删查
class SearchHistoryManager {
    static let shared = SearchHistoryManager()
    private let realm = try! Realm()
    
    /// 添加或更新搜索记录，并保持最新 10 条记录
    func addSearchRecord(word: String) {
        let trimmed = word.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        if let record = realm.object(ofType: SearchRecord.self, forPrimaryKey: trimmed.lowercased()) {
            // 更新日期，使其变为最新记录
            try! realm.write {
                record.date = Date()
            }
        } else {
            let newRecord = SearchRecord()
            newRecord.word = trimmed.lowercased()
            newRecord.date = Date()
            try! realm.write {
                realm.add(newRecord)
            }
        }
        
        // 保持最新10条记录，多余的自动删除
        let allRecords = realm.objects(SearchRecord.self).sorted(byKeyPath: "date", ascending: false)
        if allRecords.count > 10 {
            let recordsToDelete = allRecords.suffix(from: 10)
            try! realm.write {
                realm.delete(recordsToDelete)
            }
        }
        
        // 发布搜索历史更新通知
        NotificationCenter.default.post(name: .searchHistoryUpdated, object: nil)
    }
    
    /// 获取所有搜索记录，按日期降序排列
    func fetchSearchRecords() -> [SearchRecord] {
        let records = realm.objects(SearchRecord.self).sorted(byKeyPath: "date", ascending: false)
        return Array(records)
    }
    
    /// 删除指定的记录
    func deleteSearchRecord(_ record: SearchRecord) {
        try! realm.write {
            realm.delete(record)
        }
        // 删除后同样发布通知
        NotificationCenter.default.post(name: .searchHistoryUpdated, object: nil)
    }
}
