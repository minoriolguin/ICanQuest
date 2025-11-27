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
                    
                    if !profiles.isEmpty {
                        List(profiles) { p in
                            Button {
                                onSelect(p)
                            } label: {
                                HStack {
                                    Text(p.name ??  "friend").font(.headline)
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        .scrollContentBackground(.hidden)
                        .frame(maxHeight: 300)
                    }
                    NavigationLink {
                        CreateProfileView { newProfile in
                            onSelect(newProfile)
                        }
                    } label: {
                        Label("", systemImage: "plus.circle.fill")
                            .font(.title3)
                            .fontDesign(.monospaced)
                            .padding()
                    }
                }
                .padding()
            }
            
        }
    }
}
