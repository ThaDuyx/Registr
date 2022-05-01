//
//  ReportSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 30/04/2022.
//

import SwiftUI

struct ReportSection: View {
    let report: Report
    
    var body: some View {
        HStack(spacing: 20) {
            
            Image(systemName: validationImage(report: report))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.frolyRed)
                .clipShape(Circle())
            
            VStack {
                Text("Validering")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)

                Text(report.teacherValidation)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            VStack {
                Text("Dato")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)

                Text(report.date.formatSpecificDate(date: report.date))
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
            
            VStack {
                Text("Årsag")
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsBold)

                Text(report.reason)
                    .smallBodyTextStyle(color: .fiftyfifty, font: .poppinsRegular)
            }
                        
            Image(systemName: "ellipsis")
                .foregroundColor(Color.fiftyfifty)
                .padding(.trailing, 10)
        }
    }
    
    private func validationImage(report: Report) -> String {
        let denied = "tv-denied".localize
        
        if !report.validated && report.teacherValidation == denied {
            return "xmark.circle"
        } else if !report.validated && report.teacherValidation != denied {
            return "questionmark.circle"
        } else {
            return "checkmark.circle"
        }
    }
}

struct ReportSection_Previews: PreviewProvider {
    static var previews: some View {
        ReportSection(report: Report(id: "", parentName: "", parentID: "", studentName: "", studentID: "", className: "", date: Date(), endDate: Date(), timeOfDay: .morning, description: "", reason: "", validated: false, teacherValidation: "", isDoubleRegistrationActivated: nil))
    }
}