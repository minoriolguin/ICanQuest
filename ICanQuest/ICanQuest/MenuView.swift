//
//  MenuView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//


import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Text("Main Menu")
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .bold()
            }
        }

    }
}

#Preview {
    MenuView()
}
