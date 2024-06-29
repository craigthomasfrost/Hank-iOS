//
//  AnthropicService.swift
//  Hank-iOS
//
//  Created by Craig Atallah Frost on 26/06/2024.
//

import Foundation

class AnthropicService {
    private let apiKey = Env.ANTHROPIC_API_KEY
    private let urlString = "https://api.anthropic.com/v1/messages"
    
    func sendMessages(_ messages: [Message]) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let request = AnthropicRequest(model: "claude-3-sonnet-20240229", messages: messages, maxTokens: 1000)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(AnthropicResponse.self, from: data)
        return result.content.first?.text ?? ""
    }
}
