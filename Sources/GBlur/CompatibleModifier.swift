//
//  CompatibleModifier.swift
//  
//
//  Created by 大江山岚 on 2024/8/19.
//

import SwiftUI

internal struct CompatibleModifier: ViewModifier {
    public var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                content
                    .drawingGroup()
                    .allowsHitTesting(false)
                    .blur(radius: radius)
                    .scaleEffect(1 + (radius * 0.02))
                    .mask(gradientMask)
            }
    }
    
    var gradientMask: some View {
        return LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
