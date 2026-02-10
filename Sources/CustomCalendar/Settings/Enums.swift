//
//  Enums.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 20/11/2024.
//
import SwiftUI

public enum CalendarType {
    case calendarOne, calendarTwo, partialCalendar, weekCalendar
}

public enum DayIndicator {
    case none
    case one(Color)
    case two(Color, Color)
}

public enum MonthHeaderStyle {
    case full, short
}
