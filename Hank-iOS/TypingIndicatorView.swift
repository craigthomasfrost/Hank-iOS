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
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(.black.opacity(0.5))
                    .frame(width: 6, height: 6)
                    .scaleEffect(animate ? 1 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .padding(14)
        .background(.black.opacity(0.05))
        .clipShape(Capsule())
        .onAppear { animate = true }
    }
}
