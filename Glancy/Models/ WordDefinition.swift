//
//  WordDefinition.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/27.
//
import Foundation

struct WordDefinition: Codable, Identifiable {
    var id: UUID { UUID() }
    let word: String
    let definition: String
    let examples: [String]
}
