//
//  QuestListView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//

import SwiftUI

struct QuestListView: View {
    let profile: UserProfile
    @EnvironmentObject var profiles: ProfileStore


    @State private var quests: [Quest] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Available Quests")
                .task { loadQuests() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView("Loading quests…")
        } else if let errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding()
        } else if quests.isEmpty {
            Text("No quests available.")
                .foregroundStyle(.secondary)
        } else {
            List {
                ForEach(quests, id: \.id) { quest in
                    NavigationLink {
                        QuestView(quest: quest, profileId: profile.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(quest.title).font(.headline)
                            Text(quest.summary).font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    private func loadQuests() {
            defer { isLoading = false }
            guard let url = Bundle.main.url(forResource: "quests", withExtension: "json") else {
                errorMessage = "quests.json not found in bundle."
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(QuestFile.self, from: data)
                quests = decoded.quests
                errorMessage = nil
            } catch {
                errorMessage = "Failed to load quests: \(error.localizedDescription)"
            }
    }
}
