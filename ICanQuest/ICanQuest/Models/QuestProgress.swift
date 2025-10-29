//
//  QuestProgress.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import SwiftData
import Foundation

@Model
final class QuestProgress {
    var questId: String
    var currentStepIndex: Int
    var startedAt: Date
    var updatedAt: Date
    var completedAt: Data?
    var isCompleted: Bool

    init(questId: String,
         currentStepIndex: Int = 0,
         startedAt: Date = .now,
         updatedAt: Date = .now,
         completedAt: Data? = nil,
         isCompleted: Bool = false) {
        self.questId = questId
        self.currentStepIndex = currentStepIndex
        self.startedAt = startedAt
        self.updatedAt = updatedAt
        self.completedAt = completedAt
        self.isCompleted = isCompleted
    }
}
