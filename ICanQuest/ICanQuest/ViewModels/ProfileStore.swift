//
//  ProfileStore.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class ProfileStore: ObservableObject {
    @Published private(set) var profiles: [UserProfile] = []
    private let ctx: ModelContext

    init(_ ctx: ModelContext) { self.ctx = ctx }

    func load() throws {
        profiles = try ctx.fetch(
            FetchDescriptor<UserProfile>(sortBy: [.init(\.createdAt, order: .forward)])
        )
    }

    @discardableResult
    func create(name: String, avatar: Avatar? = nil) throws -> UserProfile {
        let p = UserProfile(name: name, avatar: avatar)
        ctx.insert(p)
        try ctx.save()
        try load()
        return p
    }

    func delete(_ profile: UserProfile) throws {
        ctx.delete(profile)
        try ctx.save()
        try load()
    }

    @discardableResult
    func startQuest(_ questId: String, for profile: UserProfile) throws -> QuestProgress {
        if let p = profile.activeProgress, p.questId == questId { return p }
        let progress = QuestProgress(questId: questId)
        profile.activeProgress = progress
        try ctx.save()
        try load()
        return progress
    }

    func advance(progress: QuestProgress, totalSteps: Int) throws {
        progress.currentStepIndex += 1
        progress.updatedAt = .now
        if progress.currentStepIndex >= totalSteps { progress.isCompleted = true }
        try ctx.save()
        try load()
    }

    func clearActiveProgress(for profile: UserProfile) throws {
        profile.activeProgress = nil
        try ctx.save()
        try load()
    }
}
