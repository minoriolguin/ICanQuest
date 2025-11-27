//
//  AvatarView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import SwiftUI

struct AvatarView: View {
    var body: some View {
        ZStack {
            Image("edamame")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .shadow(color: Color.black.opacity(0.2), radius: 10)
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    AvatarView()
}
