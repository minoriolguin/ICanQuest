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
            Image("splash-screen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
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

