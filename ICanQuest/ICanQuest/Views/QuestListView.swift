//
//  QuestListView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//

import SwiftUI
import SwiftData

struct QuestListView: View {
    let profile: UserProfile
    @EnvironmentObject var profiles: ProfileStore


    @State private var quests: [Quest] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                NavigationStack {
                    content
                        .task { loadQuests() }
                }

                .toolbarBackground(Color.clear, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
                            Text(quest.title)
                                .font(.headline)
                                .fontDesign(.monospaced)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
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

#Preview {
    QuestListView(profile: UserProfile(name: "Preview User"))
        .environmentObject(ProfileStore(try! ModelContext(.init(for: UserProfile.self))))
}

