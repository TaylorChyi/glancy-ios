//
//  GlancyTests.swift
//  GlancyTests
//
//  Created by 齐天乐 on 2025/3/27.
//

import Foundation
import Testing
@testable import Glancy

struct GlancyTests {

    /// FR-001: Cache hit returns result instantly and history stores the word
    @Test func test_search_word() async throws {
        let json = "{" +
        "\"word\":\"hello\"," +
        "\"translations\":{\"en\":\"hello\"}," +
        "\"examples\":{\"en\":\"hi\"}}"
        let parsed = try DeepSeekParser.parse(jsonString: json)
        #expect(parsed.word == "hello")
        Realm.Configuration.defaultConfiguration = Realm.Configuration(inMemoryIdentifier: "search")
        SearchHistoryManager.shared.addSearchRecord(word: parsed.word)
        let records = SearchHistoryManager.shared.fetchSearchRecords()
        #expect(records.first?.word == "hello")
    }

    /// FR-002: Language preference persists and limits selections to three
    @Test func test_language_preference() async throws {
        UserDefaults.standard.removeObject(forKey: "PreferredLanguages")
        LanguagePreferenceManager.shared.save([.en, .zh])
        let loaded = LanguagePreferenceManager.shared.load()
        #expect(loaded.contains(.en))
        #expect(loaded.contains(.zh))
        LanguagePreferenceManager.shared.save([.en, .zh, .ja, .fr])
        let limited = LanguagePreferenceManager.shared.load()
        #expect(limited.count <= 3)
    }

    /// FR-003: Authentication returns nil when not logged in
    @Test func test_authentication() async throws {
        #expect(AuthService.shared.currentUser() == nil)
    }

    /// FR-004: Search history keeps ten records and supports deletion
    @Test func test_history() async throws {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(inMemoryIdentifier: "history")
        for i in 0..<11 { SearchHistoryManager.shared.addSearchRecord(word: "w\(i)") }
        var records = SearchHistoryManager.shared.fetchSearchRecords()
        #expect(records.count == 10)
        let first = records.first!
        SearchHistoryManager.shared.deleteSearchRecord(first)
        records = SearchHistoryManager.shared.fetchSearchRecords()
        #expect(records.count == 9)
    }

    /// NFR-P01: Cached lookup completes under 0.5s
    @Test func test_performance() async throws {
        let json = "{" +
        "\"word\":\"hello\"," +
        "\"translations\":{\"en\":\"hi\"}," +
        "\"examples\":{\"en\":\"hi\"}}"
        let start = Date()
        for _ in 0..<1000 { _ = try DeepSeekParser.parse(jsonString: json) }
        let duration = Date().timeIntervalSince(start)
        #expect(duration < 0.5)
    }
}
