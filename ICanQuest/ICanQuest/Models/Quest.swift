//
//  Quest.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-24.
//
import Foundation

struct Quest: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let summary: String
    let steps: [QuestStep]
}

