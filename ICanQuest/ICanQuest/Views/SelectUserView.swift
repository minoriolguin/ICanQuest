//
//  SelectUserView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//
// TODO: styling, make the buttons centered
// TODO: styling, make the add new user in top left corner? or at least on the blue
// TODO: styling, make the scroll bar always visible so users know its scrollable
 
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
                    
                    if !profiles.isEmpty {
                        List(profiles) { p in
                            Button {
                                onSelect(p)
                                dismiss()
                            } label: {
                                Spacer()

                                HStack {
                                    Spacer()

                                    Text(p.name ??  "friend").font(.headline)
                                        .foregroundColor(.black)
                                    if let avatar = p.avatar, !avatar.isEmpty {
                                        Image(avatar)
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .clipShape(Circle())
                                    }

                                    Spacer()

                                }
                                Spacer()

                            }
                            .buttonStyle(.bordered)
                            .frame(maxWidth: 200)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .frame(maxHeight: 300)
                    }
                    NavigationLink {
                        CreateProfileView { newProfile in
                            onSelect(newProfile)
                            dismiss()
                        }
                    } label: {
                        Label("", systemImage: "plus.circle.fill")
                            .font(.title.monospaced())
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                .padding()
            }
            
        }
    }
}
