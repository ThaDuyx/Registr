//
//  StatisticsView.swift
//  Registr
//
//  Created by Christoffer Detlef on 24/03/2022.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
    let navigationTitle: String
    var isStudentPresented: Bool
    // This is for testing the chart
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    init(navigationTitle: String, isStudentPresented: Bool) {
        self.navigationTitle = navigationTitle
        self.isStudentPresented = isStudentPresented
    }
    
    var body: some View {
        ZStack {
            Resources.BackgroundGradient.backgroundGradient
                .ignoresSafeArea()
            VStack {
                VStack {
                    isStudentPresented ? nil : HStack {
                        Image(systemName: "star")
                            .foregroundColor(Resources.Color.Colors.darkPurple)
                        Text("Følger ikke")
                            .boldSubTitleTextStyle()
                    }
                    .padding()
                }
                .padding(.trailing, isStudentPresented ? 0 : 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(4)
                Spacer()
                VStack(spacing: 20) {
                    if isStudentPresented {
                        OptionsView(systemName: "square.and.pencil", titleText: "Indberettelser", destination: ReportListView())
                        OptionsView(systemName: "person.crop.circle.badge.questionmark", titleText: "Fravær", destination: EmptyView())
                    } else {
                        OptionsView(systemName: "star", titleText: "Historik", destination: AbsenceHistoryView(className: navigationTitle))
                        OptionsView(systemName: "person.3", titleText: "Elever", destination: StudentListView(selectedClass: navigationTitle))
                    }
                }
                Spacer()
                VStack {
                    PieChart()
                        .data(demoData)
                        .chartStyle(ChartStyle(backgroundColor: .white,
                                               foregroundColor: ColorGradient(Resources.Color.Colors.darkBlue, Resources.Color.Colors.darkBlue)))
                }
                .frame(width: 150, height: 150)
                Spacer()
                VStack(alignment: .leading, spacing: -10) {
                    Text("Statistik")
                        .darkBlueBodyTextStyle()
                        .padding(.leading, 20)
                    VStack(alignment: .center, spacing: 15) {
                        Text("4.52% fraværsprocent")
                            .lightBodyTextStyle()
                            .padding(.top, 10)
                        Text("2.54% lovligt fravær")
                            .lightBodyTextStyle()
                        Text("7.14% ulovligt fravær")
                            .lightBodyTextStyle()
                        Text("67 gange forsent")
                            .lightBodyTextStyle()
                            .padding(.bottom, 10)
                    }
                    .frame(width: 290)
                    .background(Resources.Color.Colors.darkBlue)
                    .cornerRadius(2)
                    .padding()
                }
                Spacer()
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OptionsView<TargetView: View>: View {
    let systemName: String
    let titleText: String
    let destination: TargetView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemName)
                    .frame(alignment: .leading)
                    .padding(.leading, 20)
                Text(titleText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading, -50)
            }
        }
        .buttonStyle(Resources.CustomButtonStyle.FilledButtonStyle())
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(navigationTitle: "ClassName", isStudentPresented: true)
    }
}
