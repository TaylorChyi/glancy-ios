//
//  GlancyTests.swift
//  GlancyTests
//
//  Created by 齐天乐 on 2025/3/27.
//

import Testing
@testable import Glancy

struct GlancyTests {

    @Test func example() async throws {
        // Encode the static testData into JSON and parse it back using DeepSeekParser
        let original = DeepSeekTranslationResponse.testData
        let jsonData = try JSONEncoder().encode(original)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        let parsed = try DeepSeekParser.parse(jsonString: jsonString)

        // Verify the word and one of the translations match the original values
        #expect(parsed.word == original.word)
        #expect(parsed.translations["en"] == original.translations["en"])
    }

}
