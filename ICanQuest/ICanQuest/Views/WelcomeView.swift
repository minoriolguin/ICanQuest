//
//  WelcomeView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-07.
//

import SwiftUI

struct WelcomeView: View {
    var onFinish: () -> Void
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            BackgroundView(filename: "color_fade_io")
                .ignoresSafeArea()
            
            VStack {
                Text("I Can")
                    .bold()
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .foregroundColor(.black)
                Text("Quest on to discover your emotions!")
                    .font(.subheadline)
                    .fontDesign(.serif)
                    .foregroundColor(.black)
            }
            .padding()

        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1)) {
                onFinish()
            }
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation(.easeInOut(duration: 1)) {
                    onFinish()
                }
            }
        }

    }
}

#Preview {
    WelcomeView {}
}

