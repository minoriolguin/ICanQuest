//
//  AvatarView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import SwiftUI

struct AvatarView: View {
    @Bindable var profile: UserProfile
    
    var body: some View {
        ZStack {
            if let avatar = profile.avatar {
                Image(avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
            }
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    AvatarView(profile: UserProfile(name: "friend", avatar: "edamame"))
}
