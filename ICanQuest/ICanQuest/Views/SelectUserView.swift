//
//  SelectUserView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import SwiftUI
import SwiftData

struct SelectUserView: View {
    @Environment(\.modelContext) private var ctx
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]

    var onSelect: (UserProfile) -> Void
    var onCreate: (String) -> Void

    @State private var name = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Who’s playing?")
                .font(.largeTitle).bold()
                .fontDesign(.serif)

            if !profiles.isEmpty {
                List(profiles) { p in
                    Button {
                        onSelect(p)
                    } label: {
                        HStack {
                            Text(p.name ??  "friend").font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 300)
            }

            HStack(spacing: 8) {
                TextField("New profile name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .onSubmit(createIfValid)
                    .fontDesign(.serif)

                Button("Add") { createIfValid() }
                    .background(Color.clear)
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValidName)
                    .fontDesign(.serif)
            }
        }
        .padding()
    }

    private var isValidName: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func createIfValid() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onCreate(trimmed)
        name = ""
    }
}
