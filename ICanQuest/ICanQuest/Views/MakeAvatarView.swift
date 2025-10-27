//
//  MakeAvatarView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//
import SwiftUI
import SwiftData

struct MakeAvatarView: View {
    @Environment(\.modelContext) private var ctx
    let profile: UserProfile

    @State private var shape = ""
    @State private var color = ""

    var body: some View {
        VStack {
            Text("Create Your Avatar").font(.largeTitle.bold())


            Button("Save") {
                profile.avatar = Avatar(color: color, shape: shape)
                try? ctx.save()
                
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
