//
//  CreateProfilerView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//

import SwiftUI
import SwiftData

struct CreateProfileView: View {
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss

    @State private var selectedAvatar = ""
    @State private var username = ""
    
    private let avatars = ["chickpea-happy", "kidney-bean-happy"]
    
    var onCreate: (UserProfile) -> Void = { _ in }

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                
            VStack {
                Text("Select a bean to join you on your quest")
                    .font(
                        .largeTitle
                        .bold()
                    )

                HStack(spacing: 20) {
                    ForEach(avatars, id: \.self) { name in
                        Button {
                            selectedAvatar = name
                        } label: {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .opacity(selectedAvatar == name ? 1.0 : 0.5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selectedAvatar == name ? Color.blue : Color.clear, lineWidth: 4)
                                )
                                .shadow(color: selectedAvatar == name ? .black.opacity(0.4) : .clear, radius: 8)
                                .animation(.easeInOut(duration: 0.2), value: selectedAvatar)
                        }
                    }
                }

                
                HStack {
                    Text(
                        "Name your bean to start your quest"
                    )
                    .font(.title3)
                    .lineLimit(3)
                    .padding()
                    
                    TextField(
                        "Bean name",
                        text: $username
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    Button("Save") {
                        createProfile(username: username, selectedAvatar: selectedAvatar)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedAvatar.isEmpty || username.isEmpty)
                    .fontDesign(.monospaced)
                    .padding()
                }
                
                Spacer()
            }
        }
    }

        
    private func createProfile(username: String, selectedAvatar: String) {
        let profile = UserProfile(name: username)
        profile.avatar = selectedAvatar
        
        ctx.insert(profile)
        try? ctx.save()
        
        onCreate(profile)
        dismiss()
    }
}
