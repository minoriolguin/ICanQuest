//
//  QuestStep.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-24.
//

import Foundation

struct QuestStep: Identifiable, Codable, Hashable {
    var id: String
    var text: String
    var speaker: String
}
