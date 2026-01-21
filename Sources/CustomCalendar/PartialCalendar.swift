//
//  PartialCalendar.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 12/05/2025.
//
import SwiftUI

@available(iOS 16.0, *)
public struct PartialCalendar: View {
    @StateObject var manager: CalenderManager
    
    @Binding var selectedDates: [Date]
    
    public init(selectedDates: Binding<[Date]>, colors: Colors = Colors(), startDate: Date, endDate: Date) {
        _selectedDates = selectedDates
        
        let manager = CalenderManager(
            startDate: startDate,
            endDate: endDate,
            colors: colors,
            calendarType: .partialCalendar
        )
        _manager = StateObject(wrappedValue: manager)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Weekday(manager: manager)
            
            Month(manager: manager, isLoading: .constant(false), monthOffset: 0) //Offset ignored ao partial calendar
        }
        .onAppear { manager.selectedDates = selectedDates }
        .onChange(of: manager.selectedDates) { newList in
            selectedDates = newList
        }
        .onChange(of: selectedDates) { newDates in
            manager.selectedDates = newDates
        }
    }
}
