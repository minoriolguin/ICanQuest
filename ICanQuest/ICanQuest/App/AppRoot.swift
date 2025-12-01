//
//  AppRoot.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import SwiftUI
import SwiftData

struct AppRoot: View {
    @Environment(\.modelContext) private var ctx
    
    @StateObject private var app = AppStateStore()
    @State private var editingAvatarFor: UserProfile? = nil
    @State private var resumeTarget: Quest? = nil
    @State private var showingSelectUser = false

    var onSaved: () -> Void = {}

    var body: some View {
        ZStack {
            if !app.didShowWelcome {
                WelcomeView { app.setDidShowWelcome(true) }

            }
            else if let profile = loadSelectedProfile() {
                if editingAvatarFor != nil {
                    NavigationStack {
                        EditProfileView(profile: profile)
                    }
                } else if profile.avatar == nil {
                    NavigationStack {
                        CreateProfileView()
                    }
                } else {
                    NavigationStack {
                        MenuView(
                            profile: profile,
                            onBeginNewQuest: {  },
//                            onEditAvatar: { editingAvatarFor = profile },
                            onResumeQuest: {
                                handleResume(profile: profile) { q in
                                    resumeTarget = q
                                }
                            }
                        )
                    }
                }

            }
            else {
                SelectUserView(
                    onSelect: { p in app.setSelectedProfile(p) },
                    onCreate: { name in
                        let p = UserProfile(name: name)
                        ctx.insert(p); try? ctx.save()
                        app.setSelectedProfile(p)
                    }
                )
            }
        }
        .environmentObject(app)
    }

    private func loadSelectedProfile() -> UserProfile? {
        guard let idStr = app.selectedProfileId,
              let uuid = UUID(uuidString: idStr) else { return nil }
        return try? ctx.fetch(
            FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == uuid })
        ).first
    }
    
    func handleResume(profile: UserProfile, push: (Quest) -> Void) {
        guard let qp = profile.activeProgress else { return }
        if let quest = loadAllQuests().first(where: { $0.id == qp.questId }) {
            push(quest)
        }
    }

    private func loadAllQuests() -> [Quest] {
        guard let url = Bundle.main.url(forResource: "quests", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let file = try? JSONDecoder().decode(QuestFile.self, from: data)
        else { return [] }
        return file.quests
    }

}


