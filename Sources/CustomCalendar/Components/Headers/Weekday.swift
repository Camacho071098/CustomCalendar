//
//  Weekday.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 03/11/2024.
//
import SwiftUI

struct Weekday: View {
    @StateObject var manager: CalenderManager
    
    @Binding var selectedDate: Date?
    
    var weekdays: [String] {
        Settings.getWeekdayHeaders(calendar: manager.calendar)
    }
    
    private var selectedWeekdayIndex: Int? {
        guard let selectedDate = selectedDate else { return nil }
        let weekday = manager.calendar.component(.weekday, from: selectedDate)
        let first = manager.calendar.firstWeekday
        return (weekday - first + manager.daysPerWeek) % manager.daysPerWeek
    }
    
    init(manager: CalenderManager, selectedDate: Binding<Date?> = .constant(nil)) {
        _manager = StateObject(wrappedValue: manager)
        _selectedDate = selectedDate
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { index, weekday in
                let isSelected = (index == selectedWeekdayIndex)
                
                Text(weekday)
                    .font(isSelected ? manager.fonts.selectedTextFont : manager.fonts.regularTextFont)
                    .foregroundStyle(isSelected ? manager.colors.selectedTextColor : manager.colors.weekdayTextColor)
            }
            .background(manager.colors.backgroundColor)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    Weekday(manager: CalenderManager(), selectedDate: .constant(Date()))
}
