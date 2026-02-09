//
//  DotIndicator.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 20/01/2026.
//
import SwiftUI

struct DotIndicator: View {
    let indicator: DayIndicator
    
    private let dotSize: CGFloat = 16
    
    var body: some View {
        switch indicator {
        case .none: Color.clear.frame(height: dotSize)
        case .one(let color):
            Circle()
                .fill(color)
                .frame(width: dotSize)
        case .two(let color, let color2):
            HStack(spacing: 0) {
                color
                color2
            }
            .clipShape(Circle())
            .frame(height: dotSize)
        }
    }
}
