//
//  RegisterView.swift
//  Registr
//
//  Created by Christoffer Detlef on 10/03/2022.
//

import SwiftUI

struct RegisterView: View {
    // To make the List background transparent, so the gradient background can be used.
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Resources.BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                Form {
                    Section(header: Text("Favoritter")) {
                        ClassStack()
                        ClassStack()
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    Section(header: Text("Klasser")) {
                        ClassStack()
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("Registrer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ClassStack: View {
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Image(systemName: "star")
                        .frame(alignment: .leading)
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("3.Y")
                        .frame(alignment: .center)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
        .padding(4)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
