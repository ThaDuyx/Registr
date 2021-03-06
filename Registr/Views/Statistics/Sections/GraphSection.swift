//
//  GraphSection.swift
//  Registr
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import SwiftUI
import SwiftUICharts

struct GraphSection: View {
    
    @StateObject var statisticsViewModel = StatisticsViewModel()

    var body: some View {
        if statisticsWeekDay(statistics: statisticsViewModel).isEmpty || statisticsWeekDay(statistics: statisticsViewModel).allSatisfy({ $0 == 0 }) {
            Text("stat_no_graph".localize)
                .bodyTextStyle(color: .fiftyfifty, font: .poppinsBold)
                .multilineTextAlignment(.leading)
                .frame(width: 320)
        } else {
            BarChartView(
                data: ChartData(
                    values: chartData(
                        stringArray: WeekDays.allCases.map { $0.rawValue }, 
                        doubleArray: statisticsWeekDay(statistics: statisticsViewModel).map { Double($0) })), 
                title: "stat_graph_value".localize, 
                legend: "stat_graph_description".localize,
                style: ChartsStyle.style
            )
        }    
    }
}
