//
//  ICanQuestApp.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-07.
//

import SwiftUI
import SwiftData

@main
struct ICanQuestApp: App {
    var body: some Scene {
        WindowGroup {
            AppRoot()
        }
        .modelContainer(for: [UserProfile.self, QuestProgress.self])
    }
}
