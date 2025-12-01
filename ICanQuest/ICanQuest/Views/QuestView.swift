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

    override func didMove(to view: SKView) {
        view.allowsTransparency = true
        view.backgroundColor = .clear
        backgroundColor = .clear
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let texture = SKTexture(imageNamed: "edamame")
        let beanNode = SKSpriteNode(texture: texture)
        beanNode.setScale(0.85)
        beanNode.position = CGPoint(x: size.width * 3 / 4,
                                    y: size.height / 2.6)
        addChild(beanNode)
        self.bean = beanNode
        
        let mentortexture = SKTexture(imageNamed: "AppleTeacher")
        let mentorNode = SKSpriteNode(texture: mentortexture)
        mentorNode.setScale(0.7)
        mentorNode.position = CGPoint(x: size.width / 3,
                                      y: size.height / 2.6)
        addChild(mentorNode)
        self.mentor = mentorNode
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
        
        let textures = [
            SKTexture(imageNamed: "edamame-talk-1"),
            SKTexture(imageNamed: "edamame-talk-2"),
            SKTexture(imageNamed: "edamame-talk-3"),
            SKTexture(imageNamed: "edamame-talk-2"),
            SKTexture(imageNamed: "edamame-talk-1"),
            SKTexture(imageNamed: "edamame-talk-2"),
            SKTexture(imageNamed: "edamame-talk-3"),
            SKTexture(imageNamed: "edamame-talk-2"),
            SKTexture(imageNamed: "edamame-talk-1"),
            SKTexture(imageNamed: "edamame-talk-2"),
            SKTexture(imageNamed: "edamame-talk-3"),
            SKTexture(imageNamed: "edamame-talk-2"),
            SKTexture(imageNamed: "edamame-talk-1"),
        ]
        
        let talk = SKAction.animate(with: textures, timePerFrame: 0.08)
        bean.run(talk)
    }
    
    func mentorTalk() {
        guard let mentor else { return }
        
        let textures = [
            SKTexture(imageNamed: "mentor-talk-1"),
            SKTexture(imageNamed: "mentor-talk-2"),
            SKTexture(imageNamed: "mentor-talk-1"),
            SKTexture(imageNamed: "mentor-talk-2"),
            SKTexture(imageNamed: "mentor-talk-1"),
            SKTexture(imageNamed: "mentor-talk-2"),
            SKTexture(imageNamed: "mentor-talk-1"),
        ]
        
        let talk = SKAction.animate(with: textures, timePerFrame: 0.1)
        mentor.run(talk)
    }
}

struct QuestView: View {
    let quest: Quest
    var profileId: UUID?
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    
    @State private var scene: GameScene = {
        let s = GameScene(size: CGSize(width: 300, height: 300))
        s.scaleMode = .resizeFill
        return s
    }()

    @State private var currentStepIndex: Int = 0
    @State private var progress: QuestProgress?
    
    private var currentStep: QuestStep {
        quest.steps[currentStepIndex]
    }
    
    private var isLastStep: Bool {
        currentStepIndex == quest.steps.count - 1
    }

    var body: some View {
        ZStack {
            Image(quest.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            SpriteView(scene: scene, options: [.allowsTransparency])
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
            Spacer()
            
            bottomPanel
                .padding(.horizontal, 24)
        }
        .onAppear {
            setupProgressIfNeeded()
            playStepAnimation()
        }
    }
    
    private var bottomPanel: some View {
            VStack(alignment: .leading, spacing: 12) {

                if currentStep.id == "title" {
                        Text(currentStep.text)
                        .font(.largeTitle.monospaced())
                }
                
                if !currentStep.text.isEmpty {
                    Text(currentStep.text)
                        .font(.title2.monospaced())
                }
                                
                HStack {
                    if currentStepIndex > 0 {
                        Button("Back") {
                            goBack()
                        }
                        .font(.body.monospaced())
                        .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(isLastStep ? "Finish quest" : "Next") {
                        advanceStep()
                    }
                    .font(.body.monospaced())
                    .foregroundColor(.black)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.85))
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
                if let progress {
                    progress.isCompleted = true
                    progress.updatedAt = .now
                    try? ctx.save()
                }
                dismiss()
                return
            }
            
            currentStepIndex += 1
            saveProgress()
            playStepAnimation()
        }
        
        private func goBack() {
            guard currentStepIndex > 0 else { return }
            currentStepIndex -= 1
            saveProgress()
            playStepAnimation()
        }
        
        private func playStepAnimation() {
            scene.beanTalk()
        }
    }

    #Preview {
        QuestView(quest: Quest(
            id: "preview",
            title: "Preview Quest",
            summary: "Just testing",
            background: "classroom",
            steps: [
                QuestStep(id: "s1", text: "Sprout: Hey, how are you feeling today?", speaker: "Tell me about your day."),
                QuestStep(id: "s2", text: "Sprout: That sounds tough.", speaker: "What could help you feel a bit better?"),
                QuestStep(id: "s3", text: "Sprout: You did a great job sharing.", speaker: "Take a deep breath with me.")
            ]
        ))
    }
