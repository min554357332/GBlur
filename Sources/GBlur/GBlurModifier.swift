//
//  GBlurModifier.swift
//  
//
//  Created by 大江山岚 on 2024/8/19.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
internal struct GBlurModifier: ViewModifier {
    public var radius: CGFloat
    @Environment(\.displayScale) var displayScale
    let library = ShaderLibrary.bundle(.module)
    
    var blurX: Shader {
        var shader = library.blurX(.float(radius),
                                   .float(displayScale))
        shader.dithersColor = true
        return shader
    }
    
    var blurY: Shader {
        var shader = library.blurY(.float(radius),
                                   .float(displayScale))
        shader.dithersColor = true
        return shader
    }
    
    public func body(content: Content) -> some View {
        content
            .drawingGroup()
            .layerEffect(blurX, maxSampleOffset: .zero)
            .layerEffect(blurY, maxSampleOffset: .zero)
    }
}
