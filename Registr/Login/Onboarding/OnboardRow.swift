//
//  OnboardRow.swift
//  Registr
//
//  Created by Christoffer Detlef on 09/03/2022.
//

import SwiftUI

struct OnboardRow: View {
    var id: Int
    var title: String
    var details: String
    var image: String
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Resources.Color.Colors.moonMist.opacity(0.7))
                        .frame(height: 170)
                        .cornerRadius(50, corners: [.bottomLeft, .bottomRight])
                    
                    Spacer()
                    
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white, Resources.Color.Colors.frolyRed)
                        .frame(height: 160)
                        .offset(y: 80)
                }
                .ignoresSafeArea()
                
                Spacer()
                
                VStack {
                    VStack(spacing: 40) {
                        Text(title.localize)
                            .smallDarkSubTitleTextStyle()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                        
                        Text(details.localize)
                            .mediumSubTitleTextStyle(color: Resources.Color.Colors.fiftyfifty, font: "Poppins-Regular")
                            .frame(width: 250)
                            .multilineTextAlignment(.leading)
                            .padding(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Resources.Color.Colors.frolyRed, lineWidth: 2)
                            )
                    }
                    .offset(y: 40)
                    Spacer()
                }
            }
        }
    }
}

struct OnboardRow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardRow(id: 1, title: "onboard_flow_page_one_title", details: "onboard_flow_page_one_description", image: "checkmark.shield.fill")
    }
}