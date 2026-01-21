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
