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
    var onResumeQuest: () -> Void
    
    @State private var resumeQuest: Quest? = nil

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
            HStack {
                if (profile.avatar != nil) { AvatarView() }
                VStack(alignment: .leading) {
                    Text("Welcome back, \(profile.name ?? "friend")!")
                        .font(.title)
                        .fontDesign(.monospaced)
                        .bold()
                    
                    Button("Edit Avatar") {
                        onEditAvatar()
                    }
                    .foregroundColor(.black)
                }
            }

                NavigationLink("Begin a new quest") {
                    QuestListView(profile: profile)
                }
                
            Button("Resume quest") { }
                .disabled(true)
                
                NavigationLink(destination:
                    SelectUserView(
                        onSelect: { profile in
                            print("Selected profile: \(profile.name ?? "unknown")")
                        },
                        onCreate: { name in

                            print("Created profile named: \(name)")
                        }
                    )
                ) {
                    Text("Switch Profile")
                        .font(.title3)
                        .fontDesign(.monospaced)
                }
        }
        .padding()
        .task { resumeQuest = loadQuestToResume(for: profile) }
        }
    }
    
    private func loadQuestToResume(for profile: UserProfile) -> Quest? {
        guard let qp = profile.activeProgress else { return nil }
        guard let url = Bundle.main.url(forResource: "quests", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let file = try? JSONDecoder().decode(QuestFile.self, from: data) else { return nil }
        return file.quests.first { $0.id == qp.questId }
    }
}


extension UserProfile {
    static var previewSample: UserProfile {
        UserProfile(name: "friend", avatar: "")
    }
}

#Preview("MenuView – basic") {
    NavigationStack {
        MenuView(
            profile: .previewSample,
            onBeginNewQuest: { print("Begin new quest") },
            onEditAvatar: { print("Edit avatar") },
            onResumeQuest: { print("Resume quest") }
        )
        .padding()
    }
}
