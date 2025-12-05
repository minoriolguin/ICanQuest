//
//  AppStateStore.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import SwiftUI
import Combine

@MainActor
final class AppStateStore: ObservableObject {
    @Published var didShowWelcome: Bool = false
    @Published var selectedProfileId: String?

    private let d = UserDefaults.standard
    private let selKey = "selectedProfileId"

    init() {
        selectedProfileId = d.string(forKey: selKey)
    }

    func setDidShowWelcome(_ flag: Bool) {
        didShowWelcome = flag
    }

    func setSelectedProfile(_ p: UserProfile?) {
        let id = p?.id.uuidString
        selectedProfileId = id
        d.set(id, forKey: selKey)
    }
}
