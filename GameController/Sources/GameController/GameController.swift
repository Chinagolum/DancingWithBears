
// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct GameControllerView: View {
    public var onPatternComplete: (([Int]) -> Void)?
    
    @State private var selectedDots: [Int] = []
    @State private var currentDragLocation: CGPoint = .zero
    @State private var isDragging = false

    private let gridSize = 3
    private let dotSize: CGFloat = 60

    public init(onPatternComplete: (([Int]) -> Void)? = nil) {
        self.onPatternComplete = onPatternComplete
    }

    public var body: some View {
        GeometryReader { geo in
            let positions = dotPositions(in: geo.size)
            ZStack {
                // Draw connecting lines
                Path { path in
                    guard let first = selectedDots.first else { return }
                    path.move(to: positions[first])
                    for index in selectedDots.dropFirst() {
                        path.addLine(to: positions[index])
                    }
                    if isDragging {
                        path.addLine(to: currentDragLocation)
                    }
                }
                .stroke(Color.blue, lineWidth: 6)
                .opacity(selectedDots.isEmpty ? 0 : 1)

                // Draw dots
                ForEach(0..<9) { i in
                    Circle()
                        .fill(selectedDots.contains(i) ? .blue : .gray.opacity(0.4))
                        .frame(width: dotSize, height: dotSize)
                        .position(positions[i])
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        currentDragLocation = value.location
                        for (i, pos) in positions.enumerated() {
                            if distance(from: pos, to: value.location) < dotSize / 2 {
                                if !selectedDots.contains(i) {
                                    selectedDots.append(i)
                                }
                            }
                        }
                    }
                    .onEnded { _ in
                        isDragging = false
                        onPatternComplete?(selectedDots)
                        selectedDots.removeAll()
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(40)
    }

    // MARK: - Helpers
    private func dotPositions(in size: CGSize) -> [CGPoint] {
        let spacingX = size.width / CGFloat(gridSize + 1)
        let spacingY = size.height / CGFloat(gridSize + 1)
        return (0..<gridSize).flatMap { row in
            (0..<gridSize).map { col in
                CGPoint(x: spacingX * CGFloat(col + 1), y: spacingY * CGFloat(row + 1))
            }
        }
    }

    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        hypot(from.x - to.x, from.y - to.y)
    }
}

