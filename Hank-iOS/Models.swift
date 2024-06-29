//
//  models.swift
//  Hank-iOS
//
//  Created by Craig Atallah Frost on 26/06/2024.
//

import Foundation

struct Message: Codable, Equatable {
    let role: String
    let content: String
}

struct AnthropicRequest: Codable {
    let model: String
    let messages: [Message]
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
    }
}

struct AnthropicResponse: Codable {
    let content: [AnthropicContent]
}

struct AnthropicContent: Codable {
    let text: String
}
