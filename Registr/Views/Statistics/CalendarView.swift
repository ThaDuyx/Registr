//
//  CalendarView.swift
//  Registr
//
//  Created by Christoffer Detlef on 25/03/2022.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    let className: String
    
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: Calendar.current.component(.year, from: Date()),month: 1, day: 1)
        let endComponents = DateComponents(year: Calendar.current.component(.year, from: Date()), month: 12, day: 31)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 0) {
                    Text("absence_day_pick")
                        .boldSubTitleTextStyle(color: Resources.Color.Colors.fiftyfifty)
                        .padding(.horizontal)
                    let date = DateFormatter.abbreviationDayMonthYearFormatter.string(from: selectedDate)
                    Text(date)
                        .boldSubTitleTextStyle(color: Resources.Color.Colors.fiftyfifty)
                        .padding(.horizontal)
                }
                DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()

                NavigationLink(destination: AbsenceRegistrationView(selectedClass: className, selectedDate: selectedDate.formatSpecificData(date: selectedDate), isFromHistory: true)) {
                    Text("next_view")
                }
                .buttonStyle(Resources.CustomButtonStyle.RegisterButtonStyle())
                .padding(.leading, 200)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(className: "0.x")
    }
}