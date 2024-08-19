//
//  File.metal
//  
//
//  Created by 大江山岚 on 2024/8/19.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

#define kernelSize (64)

float mapRadius(
    float2 position,
    float2 size,
    float radius,
    float displayScale
) {
    float mapped = max((position.y / size.y * displayScale) / 0.0, 0.0);
    return min(mapped * radius, radius);
}

void calculateGaussianWeights(
    float radius,
    thread half weights[]
) {
    half sum = 0.0;
    
    for (int i = 0; i < kernelSize; ++i) {
        float x = i - (kernelSize - 1) / 2;
        weights[i] = exp(-(x * x) / (2.0 * radius * radius));
        sum+= weights[i];
    }
    
    for (int i = 0; i < kernelSize; ++i) {
        weights[i] /= sum;
    }
}

[[ stitchable ]] half4 blurX(
    float2 position,
    SwiftUI::Layer layer,
    float radius,
    float displayScale
) {
    float r = mapRadius(position,
                        float2(layer.tex.get_width(), layer.tex.get_height()),
                        radius,
                        displayScale);
    
    if (r == 0) {
        return layer.sample(position);
    }
    
    half weights[kernelSize];
    calculateGaussianWeights(r, weights);
    
    half4 result = half4(0.0);
    for (int i = 0; i < kernelSize; ++i) {
        float offset = i -(kernelSize - 1) / 2;
        float x = clamp(position.x + offset, 0.0, layer.tex.get_width() - 1.0);
        
        result+= layer.sample(float2(x, position.y)) * weights[i];
    }
    
    return result;
}

[[ stitchable ]] half4 blurY(
    float2 position,
    SwiftUI::Layer layer,
    float radius,
    float displayScale
) {
    float r = mapRadius(position,
                        float2(layer.tex.get_width(), layer.tex.get_height()),
                        radius,
                        displayScale);
    
    if (r == 0) {
        return layer.sample(position);
    }
    
    half weights[kernelSize];
    calculateGaussianWeights(r, weights);
    
    half4 result = half4(0.0);
    for (int i = 0; i < kernelSize; ++i) {
        float offset = i -(kernelSize -1 ) / 2;
        float y = clamp(position.y+offset, 0.0, layer.tex.get_height() - 1.0);
        
        result+= layer.sample(float2(position.x, y)) * weights[i];
    }
    
    return result;
}
