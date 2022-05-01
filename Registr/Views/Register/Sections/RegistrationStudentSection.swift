//
//  RegistrationStudentSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct RegistrationStudentSection: View {
    @EnvironmentObject var registrationManager: RegistrationManager
    @EnvironmentObject var statisticsManager: StatisticsManager
    
    let index: Int
    let studentName: String
    let absenceReason: String?
    let studentID: String
    let isMorning: Bool
    
    init(index: Int, studentName: String, absenceReason: String?, studentID: String, isMorning: Bool) {
        self.index = index
        self.studentName = studentName
        self.absenceReason = absenceReason
        self.studentID = studentID
        self.isMorning = isMorning
    }
    
    var body: some View {
        HStack {
            Text("\(index)")
                .subTitleTextStyle(color: Color.fiftyfifty, font: .poppinsBold)
                .padding(.leading, 20)
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.fiftyfifty)
            
            Text(studentName)
                .subTitleTextStyle(color: absenceReason?.isEmpty ?? true ? Color.fiftyfifty : .frolyRed, font: .poppinsRegular)
            
            Spacer()
            
            Button { } label: {
                Text(absenceReason?.isEmpty ?? true ? "" : stringSeparator(reason: absenceReason ?? "").uppercased())
                    .frame(width: 35, height: 35)
                    .foregroundColor(.frolyRed)
                // Note: absenceReason in the following code is the old state value.
                    .onChange(of: absenceReason) { [absenceReason] newValue in
                        // Force un-wrapping because we know we have the values and would like to receive an empty String
                        statisticsManager.updateClassStatistics(oldValue: absenceReason!, newValue: newValue!)
                        statisticsManager.updateStudentStatistics(oldValue: absenceReason!, newValue: newValue!, studentID: studentID, isMorning: isMorning)
                    }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(absenceReason?.isEmpty ?? true ? Color.fiftyfifty : .frolyRed, lineWidth: 2)
            )
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
    }
}

struct RegistrationStudentSection_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationStudentSection(index: 0, studentName: "", absenceReason: "", studentID: "", isMorning: false)
    }
}