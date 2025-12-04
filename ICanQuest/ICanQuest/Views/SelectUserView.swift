//
//  SelectUserView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
 
import SwiftUI
import SwiftData

struct SelectUserView: View {
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]

    var onSelect: (UserProfile) -> Void
    var onCreate: (String) -> Void

    @State private var name = ""

    var body: some View {
        NavigationStack {
            
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Who’s playing?")
                        .font(.largeTitle)
                        .bold()
                        .fontDesign(.monospaced)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(profiles) { p in
                                Button {
                                    onSelect(p)
                                    dismiss()
                                } label: {
                                    HStack {
                                        Text(p.name ?? "friend")
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        if let avatar = p.avatar, !avatar.isEmpty {
                                            Image(avatar)
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .frame(maxWidth: 400)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    if profiles.count > 2 {
                        Image(systemName: "chevron.down")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(.bottom, 5)
                            .opacity(0.9)
                    }
                    
                    NavigationLink {
                        CreateProfileView { newProfile in
                            onSelect(newProfile)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .foregroundColor(.black)
                            .shadow(color: .white.opacity(0.6), radius: 6)
                    }
                    Spacer()
                }
                .padding()
            }
            
        }
    }
}
