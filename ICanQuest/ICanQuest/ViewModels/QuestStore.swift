//
//  QuestViewModel.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-25.
//

import Foundation
import Combine

@MainActor
final class QuestStore: ObservableObject {
    @Published private(set) var quests: [Quest] = []
    @Published private(set) var errorMessage: String?

    func loadFromBundle() {
        errorMessage = nil
        Task {
            do {
                // Using test-quests.json during development to avoid modifying production data
                // let data = try loadResource(named: "quests", ext: "json")
                let data = try loadResource(named: "test-quests", ext: "json")
                let decoded = try decodeQuestsFile(from: data)
                try validate(decoded.quests)
                quests = decoded.quests
            } catch {
                errorMessage = error.localizedDescription
                quests = []
            }
        }
    }

    private func loadResource(named: String, ext: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
            throw LoaderError.missingFile("\(named).\(ext) not found in bundle")
        }
        return try Data(contentsOf: url)
    }

    private func decodeQuestsFile(from data: Data) throws -> QuestFile {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(QuestFile.self, from: data)
    }

    private func validate(_ quests: [Quest]) throws {
        if quests.isEmpty { throw LoaderError.invalid("No quests found") }
        var seen = Set<String>()
        for q in quests {
            if q.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw LoaderError.invalid("Quest with empty id")
            }
            if !seen.insert(q.id).inserted {
                throw LoaderError.invalid("Duplicate quest id: \(q.id)")
            }
            if q.title.isEmpty { throw LoaderError.invalid("Quest \(q.id) has empty title") }
            if q.steps.isEmpty { throw LoaderError.invalid("Quest \(q.id) has no steps") }
            var stepIds = Set<String>()
            for s in q.steps {
                if s.id.isEmpty { throw LoaderError.invalid("Quest \(q.id) has a step with empty id") }
                if !stepIds.insert(s.id).inserted {
                    throw LoaderError.invalid("Duplicate step id \(s.id) in quest \(q.id)")
                }
            }
        }
    }

    enum LoaderError: LocalizedError {
        case missingFile(String)
        case invalid(String)
        var errorDescription: String? {
            switch self {
            case .missingFile(let m), .invalid(let m): return m
            }
        }
    }
}
