//
//  Week.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 20/01/2026.
//
import SwiftUI

@available(iOS 16.0, *)
struct Week: View {
    @StateObject var manager: CalenderManager
    
    @Binding var isLoading: Bool
    @Binding var selectedDate: Date?
    
    private let indicators: [Date: DayIndicator]
    
    private var weekDays: [Date?] {
        let cal = manager.calendar
        let base = selectedDate ?? Date()
        
        guard let weekInterval = cal.dateInterval(of: .weekOfYear, for: base) else { return Array(repeating: nil, count: manager.daysPerWeek) }
        
        let baseComponents = cal.dateComponents([.year, .month], from: base)
        
        return (0..<manager.daysPerWeek).map { offset in
            guard let day = cal.date(byAdding: .day, value: offset, to: weekInterval.start) else { return nil }
            
            let dayComponents = cal.dateComponents([.year, .month], from: day)
            return ((dayComponents.year == baseComponents.year) && (dayComponents.month == baseComponents.month)) ? day : nil
        }
    }
    
    init(manager: CalenderManager, isLoading: Binding<Bool>, indicators: [Date: DayIndicator], selectedDate: Binding<Date?>) {
        _manager = StateObject(wrappedValue: manager)
        _isLoading = isLoading
        _selectedDate = selectedDate
        
        self.indicators = indicators
    }

    var body: some View {
        VStack {
            if isLoading { ProgressView() }
            
            else {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(weekDays.indices, id: \.self) { index in
                        if let weekDay = weekDays[index] {
                            VStack(spacing: 2) {
                                DayCell(
                                    calendarDate: CalendarDate(
                                        date: weekDay,
                                        manager: manager,
                                        isSelected: manager.calendar.isDate(selectedDate ?? Date(), inSameDayAs: weekDay)
                                    ),
                                    cellSize: manager.cellSize
                                )
                                .onTapGesture {
                                    selectedDate = weekDay
                                    manager.tapDelegate?.didTapDate(weekDay)
                                }
                                
                                DotIndicator(indicator: indicators[weekDay] ?? .none)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        else {
                            Text("").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
        .background(manager.colors.backgroundColor)
    }
}
