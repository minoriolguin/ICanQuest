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
    var onSaved: () -> Void = {}

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()

            if !app.didShowWelcome {
                WelcomeView { app.setDidShowWelcome(true) }

            }
            else if let profile = loadSelectedProfile() {
                if let editing = editingAvatarFor {
                    NavigationStack {
                        MakeAvatarView(profile: editing)
                    }
                } else if profile.avatar == nil {
                    NavigationStack {
                        MakeAvatarView(profile: profile)
                    }
                } else {
                    NavigationStack {
                        MenuView(
                            profile: profile,
                            onBeginNewQuest: {  },
                            onEditAvatar: { editingAvatarFor = profile }
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


