//
//  QuestStep.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-24.
//

import Foundation

struct QuestStep: Identifiable, Codable, Hashable {
    var id: String
    var text: String
    var speaker: String
    // Custom display name for the speaker (e.g., "Kidney" instead of "Teacher")
    var speakerName: String?
    var options: [String]?
    // Maps each option to a custom response (e.g., "happy": "I'm glad to hear that!")
    var responses: [String: String]?
    // Follow-up question after selecting an option, use {option} as placeholder (e.g., "What is making you {option}?")
    var followUpQuestion: String?
    // Maps each option to a response that includes user's text input, use {input} as placeholder (e.g., "I'm glad you love {input}!")
    var followUpResponses: [String: String]?
    // Changes the NPC sprite at the start of this step (e.g., "kidney-bean-happy")
    var changeNPC: String?
    // Shows a text input field, and the bean responds with this template using {input} (e.g., "My name is {input}!")
    var textInputResponse: String?
    // Maps each option to an NPC response shown after the bean's response (e.g., "Do you want to sit together?": "Sure, let's go sit!")
    var npcResponses: [String: String]?
    // Custom display name for the NPC in npcResponses (e.g., "Kidney")
    var npcResponseSpeaker: String?
}
