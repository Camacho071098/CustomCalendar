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
    
    @Binding private var weekOffset: Int
    
    public init(isLoading: Binding<Bool>, colors: Colors = Colors(), selectedDate: Binding<Date?>, weekOffset: Binding<Int>, startDate: Date = Date(), indicators: Binding<[Date: DayIndicator]>, onTap: ((Date) -> Void)? = nil) {
        _isLoading = isLoading
        _indicators = indicators
        _selectedDate = selectedDate
        _weekOffset = weekOffset
        
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
            Weekday(manager: manager)
            
            Week(manager: manager, isLoading: $isLoading, indicators: indicators, weekOffset: weekOffset, selectedDate: $selectedDate)
        }
        .background(manager.colors.backgroundColor)
        .gesture(drag)
        .onAppear { syncWeekOffsetToSelectedDate() }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onEnded { value in
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)
                
                guard horizontal > vertical else { return }
                
                withAnimation {
                    // Swipe right
                    if value.translation.width > 0 {
                        weekOffset -= 1
                    }
                    // Swipe left
                    else if value.translation.width < 0 {
                        weekOffset += 1
                    }
                }
            }
    }
    
    private func syncWeekOffsetToSelectedDate() {
        guard let selected = selectedDate else { return }

        let cal = manager.calendar
        let anchor = manager.startDate ?? Date()

        let anchorWeekStart = cal.dateInterval(of: .weekOfYear, for: anchor)?.start ?? cal.startOfDay(for: anchor)
        let selectedWeekStart = cal.dateInterval(of: .weekOfYear, for: selected)?.start ?? cal.startOfDay(for: selected)

        let diff = cal.dateComponents([.weekOfYear], from: anchorWeekStart, to: selectedWeekStart).weekOfYear ?? 0

        if weekOffset != diff {
            weekOffset = diff
        }
    }
}

/*#Preview {
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

    return WeekCalendar(
        isLoading: .constant(false),
        colors: Colors(),
        startDate: d(0),
        indicators: .constant(indicators),
        onTap: { date in
            print("Tapped:", date)
        }
    )
}*/

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
                weekOffset: .constant(0),
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
