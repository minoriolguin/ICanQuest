//
//  ICanQuestApp.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-07.
//

import SwiftUI

@main
struct ICanQuestApp: App {
    @State private var showWelcome = true

        var body: some Scene {
            WindowGroup {
                if showWelcome {
                    WelcomeView {
                        showWelcome = false
                    }
                } else {
                    MenuView()
                }
            }
        }
}
