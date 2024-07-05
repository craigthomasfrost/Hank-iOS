//
//  TypingIndicatorView.swift
//  Hank-iOS
//
//  Created by Craig Atallah Frost on 22/06/2024.
//

import SwiftUI

struct TypingIndicator: View {
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<2) { row in
                HStack(spacing: 6) {
                    ForEach(0..<3) { column in
                        Rectangle()
                            .fill(Color(red: 0.85, green: 0.47, blue: 0.34))
                            .frame(width: 6, height: 6)
                            .cornerRadius(2)
                            .scaleEffect(animate ? 1 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(row * 3 + column) * 0.1),
                                value: animate
                            )
                    }
                }
            }
        }
        .padding(16)
        .onAppear { animate = true }
    }
}
