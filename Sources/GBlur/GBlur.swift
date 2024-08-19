// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct GBlurView: View {
    public let radius: CGFloat
    
    public init(_ radius: CGFloat = 8.0) {
        self.radius = radius
    }
    
    public var body: some View {
        Spacer()
            .gblur(radius: self.radius)
    }
}

extension View {
    public func gblur(radius: CGFloat = 8.0) -> some View {
        assert(radius >= 0.0, "Radius must be greater than or equal to 0")
        
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *) {
            return modifier(GBlurModifier(radius: radius))
        } else {
            return modifier(CompatibleModifier(radius: radius))
        }
    }
}
