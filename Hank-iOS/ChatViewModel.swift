//
//  ChatViewModel.swift
//  Hank-iOS
//
//  Created by Craig Atallah Frost on 26/06/2024.
//

import SwiftUI

@Observable @MainActor
class ChatViewModel {
    var messages: [Message] = []
    var currentInput: String = ""
    var isLoading = false
    
    private let anthropicService = AnthropicService()
    
    func sendMessage() {
        guard !currentInput.isEmpty else { return }
        
        let userMessage = Message(role: "user", content: currentInput)
        
        DispatchQueue.main.async {
            self.messages.append(userMessage)
            self.currentInput = ""
            self.isLoading = true
        }
        
        Task {
            do {
                let response = try await anthropicService.sendMessages(self.messages)
                DispatchQueue.main.async {
                    let assistantMessage = Message(role: "assistant", content: response)
                    self.messages.append(assistantMessage)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }
}
