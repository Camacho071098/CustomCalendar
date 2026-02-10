//
//  Month.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 03/11/2024.
//
import SwiftUI

struct Month: View {
    @State var isStartDate = true
    @ObservedObject var manager: CalenderManager
    
    @Binding var isLoading: Bool
    
    let monthOffset: Int
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    var monthsArray: [[Date]] {
        manager.calendarType == .partialCalendar ? partialMonthArray(from: manager.startDate, to: manager.endDate) : monthArray()
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            }
            
            else {
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(monthsArray, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(row, id: \.self) { cell in
                                    cellView(cell)
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(manager.colors.backgroundColor)
        .onChange(of: manager.selectedDates) { _ in
            if manager.selectedDates.isEmpty { isStartDate = true }
        }
    }
}

#Preview {
    Month(isStartDate: true, manager: CalenderManager(calendarType: .calendarTwo), isLoading: .constant(false), monthOffset: 0)
}
