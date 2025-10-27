//
//  UserData.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//
import SwiftData
import Foundation

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var name: String?
    var avatar: Avatar?
    var createdAt: Date
    var activeProgress: QuestProgress?
    var completedQuests: [Quest]?
    
    init(name: String, avatar: Avatar? = nil) {
        self.id = UUID()
        self.name = name
        self.avatar = avatar
        self.createdAt = .now
    }

}
