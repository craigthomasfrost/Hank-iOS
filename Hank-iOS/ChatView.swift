//
//  NewChatView.swift
//  Hank-iOS
//
//  Created by Craig Atallah Frost on 26/06/2024.
//

import SwiftUI

struct ChatView: View {
    @State private var viewModel = ChatViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.messages.isEmpty {
                VStack {
                    Image("EmptyState")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
            }
            if !viewModel.messages.isEmpty {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(viewModel.messages.enumerated()), id: \.offset) { index, message in
                                MessageView(message: message)
                                    .id(index)
                            }
                            if viewModel.isLoading {
                                HStack {
                                    TypingIndicator()
                                    Spacer()
                                }
                            }
                        }
                        .padding(8)
                        .padding(.bottom, 80)
                    }
                    .onChange(of: viewModel.messages) {
                        withAnimation {
                            proxy.scrollTo(viewModel.messages.count - 1, anchor: .top)
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    TextField("Type a message", text: $viewModel.currentInput, axis: .vertical)
                        .frame(minHeight: 32)
                        .lineLimit(8)
                    
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(
                                viewModel.currentInput.isEmpty ? .gray : .white
                            )
                            .frame(width: 32, height: 32)
                            .background(
                                viewModel.currentInput.isEmpty ? .black.opacity(0.1) : .black
                            )
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.currentInput.isEmpty)
                }
                .padding(8)
                .padding(.leading, 12)
                .background(
                    Color.white.opacity(0.8)
                        .background(.ultraThinMaterial)
                )
                .cornerRadius(24)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(.black.opacity(0.06))
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer(minLength: 80)
                Text(message.content)
                    .padding(.vertical, 9)
                    .padding(.leading, 15)
                    .padding(.trailing, 19)
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(ChatBubbleShape())
            }
            if message.role == "assistant" {
                Text(message.content)
                    .font(.system(.body, design: .serif))
                    .padding()
            }
        }
    }
}

#Preview {
    ChatView()
}
