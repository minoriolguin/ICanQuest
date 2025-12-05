//
//  MenuView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//
// TODO: Implement Resume Quest
// TODO: Update color of save button and exit symbol in corner

import SwiftUI
import SwiftData

struct MenuView: View {
    @EnvironmentObject private var app: AppStateStore
    @Environment(\.modelContext) private var ctx
    @Bindable var profile: UserProfile
    
    var onBeginNewQuest: () -> Void
    var onResumeQuest: () -> Void
    
    @State private var resumeQuest: Quest? = nil
    @State private var showingEditProfile = false

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                VStack {

                HStack {
                    
                NavigationLink(destination:
                                SelectUserView(
                                    onSelect: { newProfile in
                                        app.setSelectedProfile(newProfile)
                                    },
                                    onCreate: { name in
                                        let p = UserProfile(name: name)
                                        ctx.insert(p); try? ctx.save()
                                        app.setSelectedProfile(p)
                                    }
                                )
                ) {
                    Text("Switch Profile")
                        .multilineTextAlignment(.center)
                        .font(.caption.monospaced())
                        .padding(.vertical, 4)
                                .padding(.horizontal, 4)
                        .foregroundColor(.black)
                        .shadow(radius: 0.2)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 90, height: 90)
                .buttonStyle(.bordered)
                .task { resumeQuest = loadQuestToResume(for: profile) }
                Spacer()

            
            Button {
                showingEditProfile = true
            } label: {
                Text("Edit profile")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
                    .font(.caption.monospaced())
                    .foregroundColor(.black)
                    .shadow(radius: 0.2)
                    .multilineTextAlignment(.center)

            }
            .frame(width: 90, height: 90)
            .buttonStyle(.bordered)
                    
                }


                HStack {
                    
                    Spacer()
                    

                    VStack {
                        
                    if let avatar = profile.avatar {
                        Image(avatar)
                            .resizable()
                            .scaledToFill()
                            .padding(.horizontal, 24)
                            .frame(width: 100, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    }
                        Spacer()
                    }




                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Welcome back, \(profile.name ?? "friend")!")
                            .font(.title)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .fontDesign(.monospaced)
                            .bold()
                            .shadow(radius: 0.2)
                        
                        NavigationLink(destination: QuestListView(profile: profile)) {
                            Text("Begin a new quest")
                                .font(.title3.monospaced())
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .foregroundColor(.black)
                                .shadow(radius: 0.2)
                        }
                        .buttonStyle(.bordered)
                        
                        // Navigate to QuestView with saved progress if a quest is in progress
                        NavigationLink(destination: Group {
                            if let quest = resumeQuest {
                                QuestView(quest: quest, profileId: profile.id)
                            }
                        }) {
                            Text("Resume quest")
                                .font(.title3.monospaced())
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .foregroundColor(resumeQuest == nil ? .gray : .black)
                                .shadow(radius: 0.2)
                        }
                        .buttonStyle(.bordered)
                        .disabled(resumeQuest == nil)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 48)
                    Spacer()
            }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(profile: profile)
        }

            Spacer()
                }
                .padding(40)
                .padding(.horizontal, 12)
        }
        
    }
    
    private func loadQuestToResume(for profile: UserProfile) -> Quest? {
        guard let qp = profile.activeProgress else { return nil }
        // Using test-quests.json during development to avoid modifying production data
        // guard let url = Bundle.main.url(forResource: "quests", withExtension: "json"),
        guard let url = Bundle.main.url(forResource: "test-quests", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let file = try? JSONDecoder().decode(QuestFile.self, from: data) else { return nil }
        return file.quests.first { $0.id == qp.questId }
    }
}


extension UserProfile {
    static var previewSample: UserProfile {
        UserProfile(name: "friend", avatar: "kidney-bean-happy")
    }
}

#Preview("MenuView – basic") {
    NavigationStack {
        MenuView(
            profile: .previewSample,
            onBeginNewQuest: { print("Begin new quest") },
            onResumeQuest: { print("Resume quest") }
        )
        .padding()
    }
}
