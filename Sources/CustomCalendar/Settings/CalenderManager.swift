//
//  CalenderManager.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 01/11/2024.
//
import SwiftUI
import Combine

class CalenderManager: ObservableObject {
    @Published var selectedDate: Date? = nil
    @Published var disabledDates: [Date] = []
    @Published var holidays: [Date] = []
    @Published var events: [Event] = []
    @Published var colors: Colors
    @Published var disableBeforeTodayDates: Bool
    @Published var selectedDates: [Date] = []
    
    @Published var startDate: Date? = nil {
        didSet {
            if calendarType != .partialCalendar { updateSelectedDates() }
        }
    }
    @Published var endDate: Date? = nil {
        didSet {
            if calendarType != .partialCalendar { updateSelectedDates() }
        }
    }
    
    public var tapDelegate: CalendarTapDelegate?
    
    var calendar = Calendar.current
    var minimumDate = Date()
    var maximumDate = Date()
    var disabledAfterDate: Date?
    var fonts = Fonts()
    var currentDate: Date
    var indicator: DayIndicator
    var calendarType: CalendarType
    var daysPerWeek: Int
    
    init(selectedDate: Date? = nil, startDate: Date? = nil, endDate: Date? = nil, colors: Colors = Colors(), calendar: Foundation.Calendar = Calendar.current, minimumDate: Date = Date(), maximumDate: Date = Date(), disabledAfterDate: Date? = nil, disableBeforeTodayDates: Bool = true, indicator: DayIndicator = .none, daysPerWeek: Int = 7, calendarType: CalendarType = .calendarOne) {
        self.selectedDate = selectedDate
        self.startDate = startDate
        self.endDate = endDate
        self.colors = colors
        self.calendar = calendar
        self.calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.disabledAfterDate = disabledAfterDate
        self.disableBeforeTodayDates = disableBeforeTodayDates
        
        self.currentDate = minimumDate
        self.indicator = indicator
        self.daysPerWeek = daysPerWeek
        self.calendarType = calendarType
        
        updateSelectedDates()
    }
    
    var cellSize: CGFloat {
        switch calendarType {
        case .calendarOne, .partialCalendar, .weekCalendar: return 32
        case .calendarTwo: return 40
        }
    }
    
    func disabledDatesContains(date: Date) -> Bool {
        if let disabledAfterDate = disabledAfterDate, date > disabledAfterDate {
            return true
        }
        else {
            return disabledDates.contains { disabledDate in
                
                calendar.isDate(disabledDate, inSameDayAs: date)
            }
        }
    }
    
    func holidaysContains(date: Date) -> Bool {
        return holidays.contains { holiday in
            
            calendar.isDate(holiday, inSameDayAs: date)
        }
    }
    
    func firstDateMonth() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: minimumDate)
        components.day = 1
        
        return calendar.date(from: components) ?? Date()
    }
    
    func firstOfMonthForOffset(_ offset: Int) -> Date? {
        var offsetComponent = DateComponents()
        offsetComponent.month = offset
        
        return calendar.date(byAdding: offsetComponent, to: firstDateMonth())!
    }
    
    func monthHeader(monthOffset: Int, style: MonthHeaderStyle = .full) -> String {
        let date = calendar.date(byAdding: .month, value: monthOffset, to: Date())!
        let monthIndex = calendar.component(.month, from: date) - 1
        let year = calendar.component(.year, from: date)
        let monthName: String
        
        switch style {
        case .full: monthName = calendar.monthSymbols[monthIndex]
        case .short: monthName = calendar.shortMonthSymbols[monthIndex]
        }
        
        return "\(monthName) \(year)"
    }
    
    func updateCurrentDate(monthOffset: Int) {
        currentDate = calendar.date(byAdding: .month, value: monthOffset, to: Date())!
        
        minimumDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        maximumDate = calendar.date(byAdding: .month, value: 2, to: currentDate)!
    }
    
    func updateSelectedDates() {
        selectedDates.removeAll()
        
        if let startDate = startDate {
            var currentDate = startDate
            
            if let endDate = endDate {
                while currentDate <= endDate {
                    if !calendar.isDateInWeekend(currentDate) && !disabledDatesContains(date: currentDate) && !holidaysContains(date: currentDate) {
                        selectedDates.append(currentDate)
                    }
                    currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                }
            }
            
            else {
                if !calendar.isDateInWeekend(currentDate) && !disabledDatesContains(date: currentDate) && !holidaysContains(date: currentDate) {
                    selectedDates.append(currentDate)
                }
            }
        }
    }
    
    func toggleDateSelection(_ date: Date) {
        if let index = selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) }) {
            selectedDates.remove(at: index)
        } else {
            selectedDates.append(date)
            selectedDates.sort { $0 < $1 }
        }
    }
}
