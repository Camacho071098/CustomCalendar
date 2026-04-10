//
//  DayCell.swift
//  CustomCalendar
//
//  Created by Margarida Camacho on 01/11/2024.
//
import SwiftUI

struct DayCell: View {
    var calendarDate: CalendarDate
    var cellSize: CGFloat
    
    var body: some View {
        switch calendarDate.manager.calendarType {
        case .calendarTwo:
            VStack(spacing: 0) {
                Divider()
                
                Text(calendarDate.getText())
                    .frame(width: cellSize)
                    .foregroundStyle(calendarDate.getTextColor())
                    .background(calendarDate.getBackColor())
                    .font(calendarDate.font)
                    .strikethrough(calendarDate.isBeforeToday, color: calendarDate.getTextColor())
                
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 2) {
                        ForEach(calendarDate.events, id: \.id) { event in
                            Text(event.title)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: calendarDate.events.count == 1 && calendarDate.events.first?.title == "Feriado" ? cellSize * 1.2 : .infinity, alignment: .center)
                                .foregroundStyle(event.style.textColor)
                                .font(Fonts(customSize: 8).regularTextFont)
                                .background(event.style.backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                                .overlay {
                                    event.style.borderStyle
                                }
                                .frame(height: .infinity)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(2)
                }

            }
            .frame(height: cellSize * 1.8)
            
        case .weekCalendar:
            Text(calendarDate.getText())
                .frame(width: cellSize, height: cellSize)
                .foregroundStyle(calendarDate.getTextColor())
                .font(calendarDate.font)
            
        case .calendarThree:
            let event = calendarDate.events.first
            
            let isRangeEdge = calendarDate.isStartDate || calendarDate.isEndDate
            let isInRange = calendarDate.isBetween || isRangeEdge
            let isOnlyStartDate = calendarDate.isStartDate && !calendarDate.isEndDate
            let isOnlyEndDate = calendarDate.isEndDate && !calendarDate.isStartDate
            
            let isBetween = calendarDate.isBetween && !isRangeEdge
            let hasRange = (calendarDate.startDate != nil) && (calendarDate.endDate != nil)
            
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let halfW = w / 2
                
                ZStack(alignment: .center) {
                    if isInRange && hasRange {
                        ///Left Half
                        Rectangle()
                            .fill(isOnlyStartDate ? Color.clear : calendarDate.manager.colors.betweenBackColor)
                            .frame(width: halfW, height: h)
                            .offset(x: -halfW / 2)
                        
                        ///Right half
                        Rectangle()
                            .fill(isOnlyEndDate ? Color.clear : calendarDate.manager.colors.betweenBackColor)
                            .frame(width: halfW, height: h)
                            .offset(x: halfW / 2)
                    }
                    
                    ///Day circle on top
                    if isBetween {
                        ///Between dates: without clipShape  and background color
                        Text(calendarDate.getText())
                            .foregroundStyle(calendarDate.getTextColor())
                            .font(calendarDate.font)
                            .frame(width: w, height: h)
                    }
                    else {
                        ///Start, end or normal dates: original behavior
                        Text(calendarDate.getText())
                            .foregroundStyle(event?.style.textColor ?? calendarDate.getTextColor())
                            .font(calendarDate.font)
                            .frame(width: w, height: h)
                            .background(event?.style.backgroundColor ?? calendarDate.getBackColor())
                            .clipShape(Circle())
                            .overlay { isRangeEdge ? nil : event?.style.borderStyle }
                    }
                    
                }
                .frame(width: w, height: h)
            }
            .frame(height: cellSize)
            
        default:
            let event = calendarDate.events.first
            
            Text(calendarDate.getText())
                .frame(width: cellSize, height: cellSize)
                .foregroundStyle(event?.style.textColor ?? calendarDate.getTextColor())
                .font(calendarDate.font)
                .background(event?.style.backgroundColor ?? calendarDate.getBackColor())
                .clipShape(calendarDate.getBorderShape())
                .overlay {
                    event?.style.borderStyle
                }
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

/*#Preview {
    Group {
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(),
                isDisabled: true
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(),
                isToday: true
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(),
                isSelected: true
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(),
                isBetween: true
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager()
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(),
                isWeekend: true
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(calendarType: .calendarTwo),
                events: [
                    Event(
                        title: "Margarida",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "Catarina",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "João R",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "João L",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "Eduardo",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "Tiago",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "Alexandre",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    )
                ]
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(calendarType: .calendarTwo)
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(calendarType: .calendarTwo),
                events: [Event(
                    title: "Margarida",
                    date: Date(),
                    style: EventStyle(
                        backgroundColor: .white,
                        textColor: .orange,
                        borderColor: .orange,
                        borderStyle: AnyShape(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                        )
                    )
                )]
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(calendarType: .calendarTwo),
                events: [
                    Event(
                        title: "Margarida",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .orange,
                            borderColor: .orange,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        )
                    ),
                    Event(
                        title: "Catarina",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .orange,
                            borderColor: .orange,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        )
                    )
                ]
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(calendarType: .calendarTwo),
                events: [
                    Event(
                        title: "Margarida",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .orange,
                            borderColor: .orange,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        )
                    ),
                    Event(
                        title: "Catarina",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .orange,
                            borderColor: .orange,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        )
                    ),
                    Event(
                        title: "João R",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .red,
                            borderColor: .red,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.red, lineWidth: 1)
                            )
                        )
                    )
                ]
            ),
            cellSize: 32
        )
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalenderManager(calendarType: .calendarTwo),
                events: [
                    Event(
                        title: "Margarida",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .orange,
                            borderColor: .orange,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        )
                    ),
                    Event(
                        title: "Catarina",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .orange,
                            borderColor: .orange,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .strokeBorder(.orange, style: StrokeStyle(lineWidth: 1, dash: [3]))
                            )
                        )
                    ),
                    Event(
                        title: "João R",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .red,
                            borderColor: .red,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.red, lineWidth: 1)
                            )
                        )
                    ),
                    Event(
                        title: "João L",
                        date: Date(),
                        style: EventStyle(
                            backgroundColor: .white,
                            textColor: .green,
                            borderColor: .green,
                            borderStyle: AnyShape(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(.green, lineWidth: 1)
                            )
                        )
                    )
                ]
            ),
            cellSize: 32
        )
    }
}
*/
