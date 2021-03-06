//
//  AbsenceStatisticsCard.swift
//  Registr
//
//  Created by Christoffer Detlef on 01/05/2022.
//

import SwiftUI

struct AbsenceStatisticsCard: View {
    var isWeekDayUsed: Bool
    var title: String
    var statArray: [Int]
    private let weekArray: [String] = WeekDays.allCases.map { $0.rawValue }
    private let absencesReasonsArray: [String] = RegistrationType.allCases.map { $0.rawValue }
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .bodyTextStyle(color: .white, font: .poppinsRegular)
                    .padding(.top, 10)
                
                Divider()
                    .frame(height: 1)
                    .background(.white)
                
                HStack {
                    VStack() {
                        HStack {
                            ForEach(isWeekDayUsed ? weekArray : absencesReasonsArray, id: \.self) { value in
                                if !value.isEmpty {
                                    Text(value)
                                        .bodyTextStyle(color: .white, font: .poppinsRegular)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 10)
                                }
                            }
                        }
                        
                        HStack {
                            ForEach(statArray, id: \.self) { value in
                                Text("\(value)")
                                    .bodyTextStyle(color: .white, font: .poppinsRegular)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                }
            }
            .frame(width: 320)
            .background(Color.frolyRed)
            .cornerRadius(20)
        }
    }
}

struct AbsenceStatisticsCard_Previews: PreviewProvider {
    static var previews: some View {
        AbsenceStatisticsCard(isWeekDayUsed: false, title: "Title", statArray: [0, 0, 1, 2])
    }
}
