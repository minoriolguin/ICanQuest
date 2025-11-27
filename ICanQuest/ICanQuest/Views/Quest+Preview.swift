//
//  Quest+Preview.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-11-25.
//

import SwiftUI
import SpriteKit

#if DEBUG
extension Quest {
    static let preview: Quest = Quest(
        id: "1",
        title: "First Day of School",
        summary: "On your first day of school, you’ll practice saying hello, asking for help, and taking deep breaths when you feel nervous.",
        background: "playground",
        steps: [
            QuestStep(id: "2", text: "Say hello to your teacher.", prompt: "prompt"),
            QuestStep(id: "3", text: "Ask where to put your backpack.", prompt: "prompt"),
            QuestStep(id: "4", text: "Take three deep breaths before class starts.", prompt: "prompt")
        ]
    )
}
#endif
