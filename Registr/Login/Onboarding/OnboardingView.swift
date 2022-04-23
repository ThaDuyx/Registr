//
//  OnboardingView.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("currentPage") var currentPage = 1
    @AppStorage("dataAccess") var dataAccess = false
    
    let pages = [
        OnboardRow(id: 1, title: "onboard_flow_page_one_title", details: "onboard_flow_page_one_description", image: "bell.badge.circle.fill"),
        OnboardRow(id: 2, title: "onboard_flow_page_two_title", details: "onboard_flow_page_two_description", image: "lock.icloud.fill"),
        OnboardRow(id: 3, title: "onboard_flow_page_three_title", details: "onboard_flow_page_three_description", image: "checkmark.shield.fill")
    ]
    
    var body: some View {
        VStack {
            ForEach(pages, id: \.id) { page in
                if currentPage == page.id {
                    page
                        .overlay(
                            Button("next_view") {
                                withAnimation(.easeInOut) {
                                    currentPage += 1
                                }
                            }
                                .buttonStyle(Resources.CustomButtonStyle.SmallFrontPageButtonStyle())
                                .padding(.bottom, 20)
                            ,alignment: .bottom
                        )
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}