//
//  QuestView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-21.
//

import SwiftUI
import SwiftData
import SpriteKit

class GameScene: SKScene {

    private var bean: SKSpriteNode?
    private var mentor: SKSpriteNode?
    // The avatar name from the user's profile (e.g., "edamame", "chickpea", "kidney-bean")
    var avatarName: String = "edamame"
    // Store the original mentor scale for resetting
    private var originalMentorScale: CGFloat = 0.7

    override func didMove(to view: SKView) {
        view.allowsTransparency = true
        view.backgroundColor = .clear
        backgroundColor = .clear

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        // Remove any existing sprites to prevent layering issues
        removeAllChildren()

        // Use the profile's avatar for the bean sprite
        let texture = SKTexture(imageNamed: avatarName)
        let beanNode = SKSpriteNode(texture: texture)
        beanNode.setScale(0.85)
        beanNode.position = CGPoint(x: size.width * 3 / 4,
                                    y: size.height / 2.8)
        addChild(beanNode)
        self.bean = beanNode

        let mentortexture = SKTexture(imageNamed: "AppleTeacher")
        let mentorNode = SKSpriteNode(texture: mentortexture)
        mentorNode.setScale(originalMentorScale)
        mentorNode.position = CGPoint(x: size.width / 3,
                                      y: size.height / 2.6)
        addChild(mentorNode)
        self.mentor = mentorNode

        // Reset NPC state
        currentNPCSprite = "AppleTeacher"
        isNPCFlipped = false
    }

    // Reset the scene to its initial state (AppleTeacher, not flipped)
    func resetScene() {
        guard let mentor else { return }

        // Reset to AppleTeacher
        currentNPCSprite = "AppleTeacher"
        mentor.texture = SKTexture(imageNamed: "AppleTeacher")

        // Reset flip if needed
        if isNPCFlipped {
            mentor.xScale = originalMentorScale
            isNPCFlipped = false
        }
    }
    
    func spin() {
        guard let bean else { return }
        
        let textures = [
            SKTexture(imageNamed: "edamame"),
            SKTexture(imageNamed: "edamame-spin-1"),
            SKTexture(imageNamed: "edamame-spin-2"),
            SKTexture(imageNamed: "edamame-spin-3"),
            SKTexture(imageNamed: "edamame-spin-4"),
            SKTexture(imageNamed: "edamame-spin-5"),
            SKTexture(imageNamed: "edamame"),
        ]
        
        let animate = SKAction.animate(with: textures, timePerFrame: 0.08)
        bean.run(animate)
    }
    
    func bounce() {
        guard let bean else { return }
        
        let bounceUp = SKAction.moveBy(x: 0, y: 20, duration: 0.12)
        bounceUp.timingMode = .easeOut

        let bounceDown = SKAction.moveBy(x: 0, y: -20, duration: 0.16)
        bounceDown.timingMode = .easeIn

        let bounce = SKAction.sequence([bounceUp, bounceDown])
        bean.run(bounce)
    }
    
    func beanTalk() {
        guard let bean else { return }

        // Only animate if we have talk sprites for this avatar (edamame for now)
        // Other avatars will just stay static until their talk sprites are added
        guard avatarName == "edamame" else { return }

        let textures = [
            SKTexture(imageNamed: "\(avatarName)-talk-1"),
            SKTexture(imageNamed: "\(avatarName)-talk-2"),
            SKTexture(imageNamed: "\(avatarName)-talk-3"),
            SKTexture(imageNamed: "\(avatarName)-talk-2"),
            SKTexture(imageNamed: "\(avatarName)-talk-1"),
            SKTexture(imageNamed: "\(avatarName)-talk-2"),
            SKTexture(imageNamed: "\(avatarName)-talk-3"),
            SKTexture(imageNamed: "\(avatarName)-talk-2"),
            SKTexture(imageNamed: "\(avatarName)-talk-1"),
            SKTexture(imageNamed: "\(avatarName)-talk-2"),
            SKTexture(imageNamed: "\(avatarName)-talk-3"),
            SKTexture(imageNamed: "\(avatarName)-talk-2"),
            SKTexture(imageNamed: "\(avatarName)-talk-1"),
        ]

        let talk = SKAction.animate(with: textures, timePerFrame: 0.08)
        // Return to the original avatar sprite after animation
        let resetTexture = SKAction.setTexture(SKTexture(imageNamed: avatarName))
        bean.run(SKAction.sequence([talk, resetTexture]))
    }
    
    func mentorTalk() {
        guard let mentor else { return }

        // Only animate if we have talk sprites for this NPC (AppleTeacher for now)
        guard currentNPCSprite == "AppleTeacher" else { return }

        let textures = [
            SKTexture(imageNamed: "apple-teacher-talk-1"),
            SKTexture(imageNamed: "apple-teacher-talk-2"),
            SKTexture(imageNamed: "apple-teacher-talk-3"),
            SKTexture(imageNamed: "apple-teacher-talk-2"),
            SKTexture(imageNamed: "apple-teacher-talk-1"),
            SKTexture(imageNamed: "apple-teacher-talk-2"),
            SKTexture(imageNamed: "apple-teacher-talk-3"),
            SKTexture(imageNamed: "apple-teacher-talk-2"),
            SKTexture(imageNamed: "apple-teacher-talk-1"),
            SKTexture(imageNamed: "apple-teacher-talk-2"),
            SKTexture(imageNamed: "apple-teacher-talk-3"),
            SKTexture(imageNamed: "apple-teacher-talk-2"),
            SKTexture(imageNamed: "apple-teacher-talk-1"),
        ]

        let talk = SKAction.animate(with: textures, timePerFrame: 0.1)
        // Return to the original sprite after animation
        let resetTexture = SKAction.setTexture(SKTexture(imageNamed: currentNPCSprite))
        mentor.run(SKAction.sequence([talk, resetTexture]))
    }

    // The current NPC sprite name (for resetting after animations)
    var currentNPCSprite: String = "AppleTeacher"

    // Track if NPC is flipped
    var isNPCFlipped: Bool = false

    // Swap the NPC sprite to a different character
    func changeNPCSprite(to spriteName: String) {
        guard let mentor else { return }
        // Stop any running animations to prevent texture conflicts
        mentor.removeAllActions()
        currentNPCSprite = spriteName
        mentor.texture = SKTexture(imageNamed: spriteName)
        // Flip horizontally so the NPC faces the user (only if not already flipped)
        if !isNPCFlipped {
            mentor.xScale = mentor.xScale * -1
            isNPCFlipped = true
        }
    }
}

struct QuestView: View {
    let quest: Quest
    var profileId: UUID?
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    
    @State private var scene: GameScene = {
        let s = GameScene(size: CGSize(width: 800, height: 600))
        s.scaleMode = .aspectFill
        return s
    }()

    @State private var currentStepIndex: Int = 0
    @State private var progress: QuestProgress?
    // Stores the selected option to show the teacher's response before advancing
    @State private var selectedOption: String? = nil
    // Tracks whether we're showing the follow-up question with text input
    @State private var showingFollowUp: Bool = false
    // Stores user's typed response to the follow-up question
    @State private var userTextInput: String = ""
    // Tracks whether we're showing the bean's response after text input (for steps without options)
    @State private var showingTextInputResponse: Bool = false
    // Tracks whether we're showing the NPC's response after the bean's response
    @State private var showingNPCResponse: Bool = false
    // Tracks whether we're showing the quest finished screen
    @State private var showingFinishScreen: Bool = false
    // Controls the fade-in animation for the finish screen
    @State private var finishScreenOpacity: Double = 0

    private var currentStep: QuestStep {
        quest.steps[currentStepIndex]
    }
    
    private var isLastStep: Bool {
        currentStepIndex == quest.steps.count - 1
    }

    // Gets the current profile's name for use in dialogue text
    private var profileName: String {
        guard let profileId,
              let profile = try? ctx.fetch(
                  FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == profileId })
              ).first else { return "friend" }
        return profile.name ?? "friend"
    }

    // Gets the current profile's avatar for the bean sprite
    private var profileAvatar: String {
        guard let profileId,
              let profile = try? ctx.fetch(
                  FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == profileId })
              ).first else { return "edamame" }
        return profile.avatar ?? "edamame"
    }

    // Replaces {name} placeholder in text with the profile's name
    private func substituteText(_ text: String) -> String {
        text.replacingOccurrences(of: "{name}", with: profileName)
    }

    var body: some View {
        ZStack {
            Image(quest.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            SpriteView(scene: {
                // Set the avatar before the scene is presented
                scene.avatarName = profileAvatar
                return scene
            }(), options: [.allowsTransparency])
                .frame(maxWidth: 800, maxHeight: 600)
            if !showingFinishScreen {
                VStack {
                    bottomPanel
                        .padding(.top, 20)
                        .padding(.horizontal, 24)

                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
            }

            // Quest finished overlay
            if showingFinishScreen {
                Image("questcomplete")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(finishScreenOpacity)
            }
        }
        .onAppear {
            setupProgressIfNeeded()
            syncNPCStateForCurrentStep()
            playStepAnimation()
        }
    }
    
    private var bottomPanel: some View {
            VStack(alignment: .leading, spacing: 12) {

                if currentStep.id == "title" {
                    HStack{
                        Spacer()
                        Text(substituteText(currentStep.text))
                            .font(.largeTitle.monospaced().bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        Spacer()
                    }

                }

                else if !currentStep.text.isEmpty {
                    // Hide the original text when showing the teacher's response or textInputResponse
                    if selectedOption == nil && currentStep.textInputResponse == nil {
                        // Show speaker label based on who is speaking
                        if currentStep.speaker == "mentor" {
                            Text(currentStep.speakerName ?? "Teacher")
                                .font(.caption.monospaced())
                                .foregroundColor(Color(white: 0.2))
                        } else if currentStep.speaker == "bean" {
                            Text(profileName)
                                .font(.caption.monospaced())
                                .foregroundColor(Color(white: 0.2))
                        }
                        Text(substituteText(currentStep.text))
                            .font(.title2.monospaced())
                    }
                }

                // Show dialogue options if available, or show response if option was selected
                if let options = currentStep.options, !options.isEmpty {
                    if let selected = selectedOption {
                        if showingFollowUp, let followUp = currentStep.followUpQuestion {
                            // Show follow-up question with text input
                            Text("Teacher")
                                .font(.caption.monospaced())
                                .foregroundColor(Color(white: 0.2))
                            Text(followUp.replacingOccurrences(of: "{option}", with: selected))
                                .font(.title2.monospaced())
                            TextField("Type your answer...", text: $userTextInput)
                                .textFieldStyle(.roundedBorder)
                                .font(.body.monospaced())
                                .padding(.top, 8)
                            HStack {
                                Button("Back") {
                                    // Go back to option selection
                                    selectedOption = nil
                                    showingFollowUp = false
                                    userTextInput = ""
                                }
                                .font(.body.monospaced())
                                .foregroundColor(.black)
                                Spacer()
                                Button("Submit") {
                                    // Move to teacher response after submitting
                                    showingFollowUp = false
                                    scene.mentorTalk()
                                }
                                .font(.body.monospaced())
                                .foregroundColor(.black)
                                .disabled(userTextInput.isEmpty)
                            }
                        } else if showingNPCResponse, let npcResponse = currentStep.npcResponses?[selected] {
                            // Show the NPC's response after the bean's response
                            Text(currentStep.npcResponseSpeaker ?? "Teacher")
                                .font(.caption.monospaced())
                                .foregroundColor(Color(white: 0.2))
                            Text(npcResponse)
                                .font(.title2.monospaced())
                            HStack {
                                Button("Back") {
                                    showingNPCResponse = false
                                }
                                .font(.body.monospaced())
                                .foregroundColor(.black)
                                Spacer()
                                Button("Next") {
                                    selectedOption = nil
                                    userTextInput = ""
                                    showingNPCResponse = false
                                    advanceStep()
                                }
                                .font(.body.monospaced())
                                .foregroundColor(.black)
                            }
                        } else {
                            // Show the speaker's response after user selected an option (or submitted follow-up)
                            // Use followUpResponses if available and user provided input, otherwise use regular responses
                            let response: String? = {
                                if !userTextInput.isEmpty,
                                   let followUpResponse = currentStep.followUpResponses?[selected] {
                                    return followUpResponse.replacingOccurrences(of: "{input}", with: userTextInput)
                                }
                                return currentStep.responses?[selected]
                            }()

                            if let response {
                                // Show speaker label based on who is speaking
                                if currentStep.speaker == "mentor" {
                                    Text(currentStep.speakerName ?? "Teacher")
                                        .font(.caption.monospaced())
                                        .foregroundColor(Color(white: 0.2))
                                } else if currentStep.speaker == "bean" {
                                    Text(profileName)
                                        .font(.caption.monospaced())
                                        .foregroundColor(Color(white: 0.2))
                                }
                                Text(substituteText(response))
                                    .font(.title2.monospaced())
                                HStack {
                                    Button("Back") {
                                        selectedOption = nil
                                        userTextInput = ""
                                    }
                                    .font(.body.monospaced())
                                    .foregroundColor(.black)
                                    Spacer()
                                    // If there's an NPC response, show "Next" to go to it, otherwise advance step
                                    if currentStep.npcResponses?[selected] != nil {
                                        Button("Next") {
                                            showingNPCResponse = true
                                            scene.mentorTalk()
                                        }
                                        .font(.body.monospaced())
                                        .foregroundColor(.black)
                                    } else {
                                        Button("Next") {
                                            selectedOption = nil
                                            userTextInput = ""
                                            advanceStep()
                                        }
                                        .font(.body.monospaced())
                                        .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    } else {
                        // Show the option buttons centered in a 2x2 grid
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(Array(options.prefix(2).enumerated()), id: \.element) { index, option in
                                    Button(option) {
                                        selectedOption = option
                                        if currentStep.followUpQuestion != nil {
                                            showingFollowUp = true
                                        } else if currentStep.speaker == "bean" {
                                            scene.beanTalk()
                                        } else {
                                            scene.mentorTalk()
                                        }
                                    }
                                    .font(.title2.monospaced())
                                    .frame(minWidth: 120)
                                    .padding(.vertical, 18)
                                    .padding(.horizontal, 28)
                                    .background(optionColor(for: index))
                                    .cornerRadius(16)
                                    .foregroundColor(.black)
                                }
                            }
                            HStack(spacing: 12) {
                                ForEach(Array(options.dropFirst(2).enumerated()), id: \.element) { index, option in
                                    Button(option) {
                                        selectedOption = option
                                        if currentStep.followUpQuestion != nil {
                                            showingFollowUp = true
                                        } else if currentStep.speaker == "bean" {
                                            scene.beanTalk()
                                        } else {
                                            scene.mentorTalk()
                                        }
                                    }
                                    .font(.title2.monospaced())
                                    .frame(minWidth: 120)
                                    .padding(.vertical, 18)
                                    .padding(.horizontal, 28)
                                    .background(optionColor(for: index + 2))
                                    .cornerRadius(16)
                                    .foregroundColor(.black)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        // Back button for option selection screen
                        if currentStepIndex > 0 {
                            HStack {
                                Button("Back") {
                                    goBack()
                                }
                                .font(.body.monospaced())
                                .foregroundColor(.black)
                                Spacer()
                            }
                        }
                    }
                } else if let textInputResponse = currentStep.textInputResponse {
                    // Step with text input (no options) - bean responds after typing
                    if showingTextInputResponse {
                        // Show the bean's response with the user's input
                        Text(profileName)
                            .font(.caption.monospaced())
                            .foregroundColor(Color(white: 0.2))
                        Text(textInputResponse.replacingOccurrences(of: "{input}", with: userTextInput))
                            .font(.title2.monospaced())
                        HStack {
                            Button("Back") {
                                showingTextInputResponse = false
                            }
                            .font(.body.monospaced())
                            .foregroundColor(.black)
                            Spacer()
                            Button("Next") {
                                showingTextInputResponse = false
                                userTextInput = ""
                                advanceStep()
                            }
                            .font(.body.monospaced())
                            .foregroundColor(.black)
                        }
                    } else {
                        // Show the mentor's question text above the input field
                        if currentStep.speaker == "mentor" && !currentStep.text.isEmpty {
                            Text(currentStep.speakerName ?? "Teacher")
                                .font(.caption.monospaced())
                                .foregroundColor(Color(white: 0.2))
                            Text(currentStep.text)
                                .font(.title2.monospaced())
                        }
                        // Show text input field
                        TextField("Type your answer...", text: $userTextInput)
                            .textFieldStyle(.roundedBorder)
                            .font(.body.monospaced())
                            .padding(.top, 8)
                        HStack {
                            if currentStepIndex > 0 {
                                Button("Back") {
                                    goBack()
                                }
                                .font(.body.monospaced())
                                .foregroundColor(.black)
                            }
                            Spacer()
                            Button("Submit") {
                                showingTextInputResponse = true
                                scene.beanTalk()
                            }
                            .font(.body.monospaced())
                            .foregroundColor(.black)
                            .disabled(userTextInput.isEmpty)
                        }
                    }
                } else {
                    // Show Back/Next buttons when no options
                    HStack {
                        if currentStepIndex > 0 {
                            Button("Back") {
                                goBack()
                            }
                            .font(.body.monospaced())
                            .foregroundColor(.black)
                        }

                        Spacer()

                        Button("Next") {
                            advanceStep()
                        }
                        .font(.body.monospaced())
                        .foregroundColor(.black)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.75))
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        }

        
        private func setupProgressIfNeeded() {
            guard let profileId else {
                currentStepIndex = 0
                return
            }
            
            guard let profile = try? ctx.fetch(
                FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == profileId })
            ).first else {
                currentStepIndex = 0
                return
            }

            if let existing = profile.activeProgress, existing.questId == quest.id {
                progress = existing
                currentStepIndex = min(existing.currentStepIndex,
                                       max(quest.steps.count - 1, 0))
            } else {
                let newProgress = QuestProgress(questId: quest.id)
                profile.activeProgress = newProgress
                progress = newProgress
                currentStepIndex = 0
                try? ctx.save()
            }
        }
        
        private func saveProgress() {
            guard let progress else { return }
            progress.currentStepIndex = currentStepIndex
            progress.updatedAt = .now
            try? ctx.save()
        }
        
        
        private func advanceStep() {
            guard !quest.steps.isEmpty else { return }

            if isLastStep {
                // Clear progress when quest is finished so it starts fresh next time
                if let profileId,
                   let profile = try? ctx.fetch(
                       FetchDescriptor<UserProfile>(predicate: #Predicate { $0.id == profileId })
                   ).first {
                    profile.activeProgress = nil
                    try? ctx.save()
                }
                showFinishScreen()
                return
            }

            currentStepIndex += 1
            saveProgress()
            playStepAnimation()
        }

        private func showFinishScreen() {
            showingFinishScreen = true
            // Fade in the black overlay and text
            withAnimation(.easeIn(duration: 1.5)) {
                finishScreenOpacity = 1.0
            }
            // After showing the finish screen, dismiss after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                dismiss()
            }
        }
        
        private func goBack() {
            guard currentStepIndex > 0 else { return }
            currentStepIndex -= 1
            saveProgress()
            syncNPCStateForCurrentStep()
            playStepAnimation()
        }

        // Sync NPC sprite state based on all steps up to current step
        // This ensures correct NPC is shown when navigating back or resuming
        private func syncNPCStateForCurrentStep() {
            // Find the most recent NPC change at or before current step
            var targetNPC: String? = nil
            for i in 0...currentStepIndex {
                if let npc = quest.steps[i].changeNPC {
                    targetNPC = npc
                }
            }

            if let targetNPC {
                // We should have a changed NPC at this point
                if scene.currentNPCSprite != targetNPC {
                    scene.changeNPCSprite(to: targetNPC)
                }
            } else {
                // No NPC change has happened yet, ensure we're on AppleTeacher
                if scene.currentNPCSprite != "AppleTeacher" {
                    scene.resetScene()
                }
            }
        }

        // Play the appropriate character animation based on who is speaking
        private func playStepAnimation() {
            // Check if we need to swap the NPC sprite for this step
            if let newNPC = currentStep.changeNPC {
                scene.changeNPCSprite(to: newNPC)
            }

            if currentStep.speaker == "bean" {
                scene.beanTalk()
            } else if currentStep.speaker == "mentor" {
                scene.mentorTalk()
            }
        }

        private func optionColor(for index: Int) -> Color {
            let colors: [Color] = [
                .yellow.opacity(0.75),
                .blue.opacity(0.75),
                .purple.opacity(0.75),
                .orange.opacity(0.75)
            ]
            return colors[index % colors.count]
        }
    }

    #Preview {
        QuestView(quest: Quest(
            id: "preview",
            title: "Preview Quest",
            summary: "Just testing",
            background: "classroom",
            steps: [
                QuestStep(id: "title", text: "Welcome to your first day of school!", speaker: "Tell me about your day."),                QuestStep(id: "s1", text: "Sprout: Hey, how are you feeling today?", speaker: "Tell me about your day."),
                QuestStep(id: "s2", text: "Sprout: That sounds tough.", speaker: "mentor"),
                QuestStep(id: "s3", text: "Sprout: You did a great job sharing.", speaker: "bean")
            ]
        ))
    }
