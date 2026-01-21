//
//  MonthHeader.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 04/11/2024.
//
import SwiftUI

struct MonthHeader: View {
    var manager: CalenderManager
    @Binding var monthOffset: Int
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        HStack {
            
            Image(.arrowLeft)
                .foregroundStyle(manager.colors.selectedTextColor)
                .onTapGesture { monthOffset -= 1 }
            
            Text(manager.monthHeader(monthOffset: monthOffset))
                .font(manager.fonts.headerTextFont)
                .foregroundStyle(manager.colors.normalTextColor)
                .frame(maxWidth: .infinity)
                .onTapGesture { isPickerPresented = true }
            
            Image(.arrowRight)
                .foregroundStyle(manager.colors.selectedTextColor)
                .onTapGesture { monthOffset += 1 }
        }
    }
}

#Preview {
    MonthHeader(manager: CalenderManager(), monthOffset: .constant(0), isPickerPresented: .constant(false))
}
