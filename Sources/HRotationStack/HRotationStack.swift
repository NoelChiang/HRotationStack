// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


@available(iOS 13.0, *)
public struct HRotationStack<Content: View>: View {
    /// Amount of view, body will use this value as iterating times to execute viewBuilder
    var viewAmount: Int
    
    /// View builder to create content, provided index to indicate current sequence of stack
    @ViewBuilder var content: (_ index: Int) -> Content
    
    /// Corresponded index of dragging position when draggin happened
    @State private var draggingPos = 0.0
    
    /// Index of center view
    @State private var lastDragged = 0.0
    
    /// Left and right side padding of center view
    private let sideEdge: CGFloat = 20
    
    /// Width of center view
    private var viewWidth: CGFloat {
        UIScreen.main.bounds.width - (sideEdge * 2)
    }
    
    public var body: some View {
        ZStack {
            ForEach(0..<viewAmount, id: \.self) {
                content($0)
                    .frame(width: viewWidth)
                // Each index diff get 0.77x scale, the larger index diff, the smaller scale
                    .scaleEffect(pow(0.77, abs(shiftPos($0))), anchor: .bottom)
                
                // Offset views to left (minus index diff) or right (positive index diff)
                    .offset(x: offsetX($0), y: -abs(offsetX($0) * 0.3))
                
                // View with larger index diff will be in the bottom of ZStack
                    .zIndex(1 - abs(shiftPos($0)) * 0.1)
            }
            .gesture(
                DragGesture()
                    .onChanged({ gesture in
                        draggingPos = lastDragged - gesture.translation.width / (viewWidth * 0.5)
                    })
                    .onEnded({ gesture in
                        withAnimation(.smooth) {
                            draggingPos = lastDragged - gesture.translation.width / (viewWidth * 0.5)
                            draggingPos = round(draggingPos)
                            if draggingPos < 0 {
                                draggingPos = 0
                            }
                            if draggingPos >= Double(viewAmount) {
                                draggingPos = Double(viewAmount) - 1
                            }
                            lastDragged = draggingPos
                        }
                    })
            )
        }
    }
    
    /// @Param index: providing index of certain view
    /// return the difference between provided index and current dragging position
    private func shiftPos(_ index: Int) -> CGFloat {
        return Double(index) - draggingPos
    }
    
    /// @Param index: providing index of certain view
    /// refer to shiftPos, 1 index diff = 9 degree angle, max = 90 degree
    /// return cos(angle) as the offset value
    private func offsetX(_ index: Int) -> CGFloat {
        let arcUnit = (Double.pi / 2) / 10.0
        var arc = arcUnit * shiftPos(index)
        if arc > .pi / 2 {
            arc = Double.pi / 2
        }
        return sin(arc) * viewWidth
    }
}
