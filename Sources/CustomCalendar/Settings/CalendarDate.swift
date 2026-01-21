//
//  CalendarDate.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 01/11/2024.
//
import SwiftUI

struct CalendarDate {
    var date: Date
    var manager: CalenderManager
    var isDisabled = false
    var isToday = false
    var isSelected = false
    var isBetween = false
    var isWeekend = false
    var isHoliday = false
    var isAbsence = false
    var isBeforeToday = false
    var events: [Event] = []
    var endDate: Date?
    var startDate: Date?
    
    init(date: Date, manager: CalenderManager, isDisabled: Bool = false, isToday: Bool = false, isSelected: Bool = false, isBetween: Bool = false, isWeekend: Bool = false, isHoliday: Bool = false, isAbsence: Bool = false, isBeforeToday: Bool = false, endDate: Date? = nil, startDate: Date? = nil, events: [Event] = []) {
        self.date = date
        self.manager = manager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetween = isBetween
        self.isWeekend = isWeekend
        self.isHoliday = isHoliday
        self.isAbsence = isAbsence
        self.isBeforeToday = isBeforeToday
        self.endDate = endDate
        self.startDate = startDate
        self.events = events
    }
    
    var isEndDate: Bool {
        date == endDate
    }
    
    var isStartDate: Bool {
        date == startDate
    }
    
    var isWeekCalendar: Bool {
        manager.calendarType == .weekCalendar
    }
    
    var font: Font {
        if isSelected { return manager.fonts.selectedTextFont }
        
        return manager.fonts.regularTextFont
    }
    
    func getText() -> String {
        let day = Settings.formatDate(date: date)
        return day
    }
    
    func getTextColor() -> Color {
        if (isSelected || isToday) || !isWeekCalendar { return manager.colors.selectedTextColor }
        else if isWeekend { return manager.colors.weekendTextColor }
        else if isHoliday { return manager.colors.holidayTextColor }
        else if isAbsence { return manager.colors.absenceTextColor }
        
        return manager.colors.normalTextColor
    }
    
    func getBackColor() -> Color {
        if isSelected { return manager.colors.selectedBackColor }
        else if isAbsence { return manager.colors.absenceBackColor }
        else if isBetween { return manager.colors.betweenBackColor }
        else if isHoliday { return manager.colors.holidayBackColor }
        
        return manager.colors.backgroundColor
    }
    
    func getBorderColor() -> Color {
        if isAbsence { return manager.colors.absenceBorderColor }
        else if isHoliday { return manager.colors.holidayBorderColor }
        
        return manager.colors.normalBorderColor
    }
    
    func getBorderShape() -> some Shape {
        if isSelected || isBetween { return AnyShape(Circle()) }
        
        return AnyShape(RoundedRectangle(cornerRadius: 8))
    }
}
