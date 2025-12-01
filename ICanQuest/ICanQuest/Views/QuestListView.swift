//
//  QuestListView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
// TODO: update font style & color

import SwiftUI
import SwiftData

struct QuestListView: View {
    let profile: UserProfile
    @EnvironmentObject var profiles: ProfileStore

    @State private var quests: [Quest] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var schoolQuests: [Quest] {
        quests.filter { $0.background == "classroom" }
    }

    private var playgroundQuests: [Quest] {
        quests.filter { $0.background == "playground" }
    }

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("Choose a quest")
                    .font(.title2.monospaced())
                    .foregroundColor(.black)

            NavigationStack {
                content
                    .task { loadQuests() }
                Spacer()
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            }
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
        } else {
            HStack(spacing: 24) {
                if let schoolQuest = schoolQuests.first {
                    NavigationLink {
                        QuestView(quest: schoolQuest, profileId: profile.id)
                    } label: {
                        LocationCard(
                            title: "Go to School",
                            subtitle: "Practice school feelings",
                            imageName: "classroom"
                        )
                    }
                }

                if let parkQuest = playgroundQuests.first {
                    NavigationLink {
                        QuestView(quest: parkQuest, profileId: profile.id)
                    } label: {
                        LocationCard(
                            title: "Go to Playground",
                            subtitle: "Practice park & playtime feelings",
                            imageName: "playground"
                        )
                    }
                }
            }
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
    
    struct LocationCard: View {
        let title: String
        let subtitle: String
        let imageName: String

        var body: some View {
            ZStack {
                
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 320, height: 160)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.monospaced())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
            }
            .frame(maxWidth: 320, maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(Color.white.opacity(0.6))
            .cornerRadius(20)
        }
    }

}

#Preview {
    QuestListView(profile: UserProfile(name: "Preview User"))
        .environmentObject(ProfileStore(try! ModelContext(.init(for: UserProfile.self))))
}

