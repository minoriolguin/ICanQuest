//
//  MenuView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//

import SwiftUI

struct MenuView: View {
    let profile: UserProfile
    var onBeginNewQuest: () -> Void
    var onEditAvatar: () -> Void
    
    @State private var resumeQuest: Quest? = nil

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if let a = profile.avatar { AvatarView(avatar: a) }
                VStack(alignment: .leading) {
                    Text("Welcome back, \(profile.name ?? "friend")!").font(.title).bold()
                    Button("Edit Avatar") { onEditAvatar() }
                }
            }

            NavigationLink("Begin a new quest") { QuestListView(profile: profile) }
                .buttonStyle(.borderedProminent)
                
            Button("Resume quest") { }
                .disabled(true)
        }
        .padding()
        .toolbarBackground(Color.clear)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Menu")
        .task { resumeQuest = loadQuestToResume(for: profile) }

    }
    
    private func loadQuestToResume(for profile: UserProfile) -> Quest? {
        guard let qp = profile.activeProgress else { return nil }
        guard let url = Bundle.main.url(forResource: "quests", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let file = try? JSONDecoder().decode(QuestFile.self, from: data) else { return nil }
        return file.quests.first { $0.id == qp.questId }
    }
}

