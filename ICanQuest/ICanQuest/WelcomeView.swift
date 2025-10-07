//
//  WelcomeView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-07.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            BackgroundView(filename: "color_fade_io")
                .ignoresSafeArea()
            
            VStack {
                Text("I Can")
                    .bold()
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .foregroundColor(.black)
                Text("A quest to connect with your emotions")
                    .font(.subheadline)
                    .fontDesign(.serif)
                    .italic()
                    .foregroundColor(.black)

                
            }
            .padding()

        }

    }
}

#Preview {
    WelcomeView()
}

