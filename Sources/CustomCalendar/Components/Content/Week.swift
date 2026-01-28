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
    
    private let daysPerWeek = 7
    private let indicators: [Date: DayIndicator]
    private let weekOffset: Int
    
    private var weekDays: [Date] {
        let cal = manager.calendar
        let startDate = manager.startDate ?? Date()

        let anchorWeekStart =
            cal.dateInterval(of: .weekOfYear, for: startDate)?.start
            ?? cal.startOfDay(for: startDate)

        let startOfWeek =
            cal.date(byAdding: .weekOfYear, value: weekOffset, to: anchorWeekStart)
            ?? anchorWeekStart

        return (0..<daysPerWeek).compactMap { day in
            guard let d = cal.date(byAdding: .day, value: day, to: startOfWeek) else { return nil }
            return cal.startOfDay(for: d)
        }
    }
    
    init(manager: CalenderManager, isLoading: Binding<Bool>, indicators: [Date: DayIndicator], weekOffset: Int, selectedDate: Binding<Date?>) {
        _manager = StateObject(wrappedValue: manager)
        _isLoading = isLoading
        _selectedDate = selectedDate
        
        self.indicators = indicators
        self.weekOffset = weekOffset
    }

    var body: some View {
        VStack {
            if isLoading { ProgressView() }
            
            else {
                HStack {
                    ForEach(weekDays, id: \.self) { weekDay in
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
                    }
                }
            }
        }
        .background(manager.colors.backgroundColor)
    }
}
