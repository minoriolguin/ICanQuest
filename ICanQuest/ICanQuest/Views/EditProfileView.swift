//
//  EditProfileView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-28.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    let profile: UserProfile
    
    @State private var selectedAvatar = ""
    @State private var username = ""
    
    private let avatars = ["chickpea-happy", "kidney-bean-happy", "edamame"]
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("Change character?")
                        .font(.largeTitle.monospaced())
                    

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
                        .frame(maxWidth: 275)
                        .padding()
                        .fontDesign(.monospaced)

                        
                        TextField(
                            "Bean name",
                            text: $username
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .background(Color.white.opacity(0.1))
//                        TODO: make white a bit more transparent
                        .frame(maxWidth: 225)
                        .padding()
                        
                        Button("Save") {
                            saveProfile()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedAvatar.isEmpty || username.isEmpty)
                        .fontDesign(.monospaced)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.horizontal, 6)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            if username.isEmpty {
                username = profile.name ?? ""
            }
            if selectedAvatar.isEmpty {
                selectedAvatar = profile.avatar ?? ""
            }
        }

        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
    
    private func saveProfile() {
        profile.name = username
        profile.avatar = selectedAvatar
        
        do {
            try ctx.save()
        } catch {
            print("Failed to save profile: \(error)")
        }
        
        dismiss()
    }
}
