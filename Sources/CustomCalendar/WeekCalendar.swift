//
//  WeekCalendar.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 20/01/2026.
//
import SwiftUI

@available(iOS 16.0, *)
public struct WeekCalendar: View {
    @StateObject var manager: CalenderManager
    
    @Binding var isLoading: Bool
    @Binding var indicators: [Date: DayIndicator]
    @Binding var selectedDate: Date?
    
    private var monthOffset: Int {
        let currentDate = manager.calendar.dateComponents([.year, .month], from: Date())
        let selectedDate = manager.calendar.dateComponents([.year, .month], from: selectedDate ?? Date())
        
        let currentYear = currentDate.year ?? 0
        let currentMonth = currentDate.month ?? 1
        
        let selectedYear = selectedDate.year ?? 0
        let selectedMonth = selectedDate.month ?? 1
        
        return ((selectedYear - currentYear) * 12) + (selectedMonth - currentMonth)
    }
    
    public init(isLoading: Binding<Bool>, colors: Colors = Colors(), selectedDate: Binding<Date?>, startDate: Date = Date(), indicators: Binding<[Date: DayIndicator]>, onTap: ((Date) -> Void)? = nil) {
        _isLoading = isLoading
        _indicators = indicators
        _selectedDate = selectedDate
        
        let manager = CalenderManager(
            startDate: startDate,
            colors: colors,
            calendarType: .weekCalendar,
        )
        manager.tapDelegate = CalendarTapHandler(onTap: onTap)
        _manager = StateObject(wrappedValue: manager)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(manager.monthHeader(monthOffset: monthOffset, style: .short))
                .font(manager.fonts.headerTextFont)
                .foregroundStyle(manager.colors.normalTextColor)
                .padding(.bottom)
            
            Weekday(manager: manager, selectedDate: $selectedDate)
            
            Week(manager: manager, isLoading: $isLoading, indicators: indicators, selectedDate: $selectedDate)
        }
        .background(manager.colors.backgroundColor)
    }
}

#Preview {
    WeekPreviewDark(selectedDate: .constant(Date()))
}

@available(iOS 16.0, *)
private struct WeekPreviewDark: View {
    @Binding var selectedDate: Date?
    
    var body: some View {
        let cal = Calendar.current
        let today = Date()

        func d(_ offset: Int) -> Date {
            cal.startOfDay(for: cal.date(byAdding: .day, value: offset, to: today)!)
        }

        let indicators: [Date: DayIndicator] = [
            d(0): .one(.green),
            d(1): .two(.red, .blue),
            d(3): .one(.orange),
            d(4): .two(.purple, .pink)
        ]

        return ZStack {
            Color.black.ignoresSafeArea()

            WeekCalendar(
                isLoading: .constant(false),
                colors: Colors(),
                selectedDate: .init(projectedValue: $selectedDate),
                startDate: d(0),
                indicators: .constant(indicators),
                onTap: { date in
                    print("Tapped:", date)
                }
            )
            .padding()
        }
    }
}
