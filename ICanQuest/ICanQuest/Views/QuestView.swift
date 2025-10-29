//
//  QuestView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//

import SwiftUI
import SwiftData

struct QuestView: View {
    let quest: Quest
    var profileId: UUID?
    @Environment(\.modelContext) private var ctx


    var body: some View {
        ZStack {
            Image(quest.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            List {
                Section(quest.title) {
                    Text(quest.summary).foregroundStyle(.secondary)
                }
                .listRowBackground(Color.clear)

//                Section("Steps") {
//                    ForEach(quest.steps, id: \.id) { s in
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(s.text)
//                            
//                        }
//                    }
//                }
//                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    func markStepDone(idx: Int) {
            guard let profileId,
                  let profile = try? ctx.fetch(
                      FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == profileId })
                  ).first
            else { return }

            if let progress = profile.activeProgress, progress.questId == quest.id {
                progress.currentStepIndex = idx + 1
                progress.updatedAt = .now
                if progress.currentStepIndex >= quest.steps.count {
                    progress.isCompleted = true
                }
                try? ctx.save()
            }
        }
}
