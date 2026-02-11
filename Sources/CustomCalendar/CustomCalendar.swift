// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

@available(iOS 16.0, *)
public struct CustomCalendar: View {
    @StateObject var manager: CalenderManager
    
    @Binding var monthOffset: Int
    @Binding var isPickerPresented: Bool
    @Binding var isLoading: Bool
    @Binding var currentDate: Date
    @Binding var selectedDates: [Date]
    @Binding var eventList: [Event]
    @Binding var shouldClearData: Bool
    
    private var enableHorizontalScroll: Bool
    
    public init(monthOffset: Binding<Int>, isPickerPresented: Binding<Bool>, isLoading: Binding<Bool>, shouldClearData: Binding<Bool> = .constant(false), currentDate: Binding<Date>, selectedDates: Binding<[Date]>, eventList: Binding<[Event]>, colors: Colors = Colors(), disableBeforeTodayDates: Bool = true, calendarType: CalendarType = .calendarOne, enableHorizontalScroll: Bool = false, onTap: ((Date) -> Void)? = nil) {
        _monthOffset = monthOffset
        _isPickerPresented = isPickerPresented
        _currentDate = currentDate
        _selectedDates = selectedDates
        _eventList = eventList
        _isLoading = isLoading
        _shouldClearData = shouldClearData
        
        let manager = CalenderManager(
            colors: colors,
            calendar: Calendar.current,
            minimumDate: Date(),
            maximumDate: Calendar.current.date(byAdding: .month, value: 2, to: Date())!,
            disableBeforeTodayDates: disableBeforeTodayDates,
            calendarType: calendarType
        )
        manager.tapDelegate = CalendarTapHandler(onTap: onTap)
        _manager = StateObject(wrappedValue: manager)
        
        self.enableHorizontalScroll = enableHorizontalScroll
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                
                MonthHeader(manager: manager, monthOffset: $monthOffset, isPickerPresented: $isPickerPresented)
                
                Weekday(manager: manager)
                
                Month(manager: manager, isLoading: $isLoading, monthOffset: monthOffset)
                
            }
            .onChange(of: monthOffset) { offset in
                manager.updateCurrentDate(monthOffset: offset)
                currentDate = manager.currentDate
            }
            .onChange(of: eventList) { newList in
                manager.events.removeAll()
                manager.events = newList
            }
            .onChange(of: manager.selectedDates) { newList in
                selectedDates = newList
            }
            .onChange(of: shouldClearData) { clearData in
                if clearData {
                    manager.startDate = nil
                    shouldClearData = false
                }
            }
        }
        .background(manager.colors.backgroundColor)
        .gesture(enableHorizontalScroll ? drag : nil)
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
                        monthOffset -= 1
                    }
                    // Swipe left
                    else if value.translation.width < 0 {
                        monthOffset += 1
                    }
                }
            }
    }
}

class CalendarTapHandler: CalendarTapDelegate {
    var onTap: ((Date) -> Void)?
    
    init(onTap: ((Date) -> Void)? = nil) {
        self.onTap = onTap
    }
    
    func didTapDate(_ date: Date) {
        onTap?(date)
    }
}

#Preview {
    CustomCalendar(monthOffset: .constant(0), isPickerPresented: .constant(false), isLoading: .constant(true), shouldClearData: .constant(true), currentDate: .constant(Date()), selectedDates: .constant([]), eventList: .constant([]))
}
