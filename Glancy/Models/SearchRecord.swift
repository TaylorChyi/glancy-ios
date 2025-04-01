//
//  SearchRecord.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/31.
//

import Foundation
import LeanCloud

import RealmSwift

class SearchRecord: Object {
    @Persisted(primaryKey: true) var word: String
    @Persisted var date: Date
}
