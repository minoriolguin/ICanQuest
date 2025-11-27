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
    
    private var bean: SKSpriteNode!
    private var mentor: SKSpriteNode!

    override func didMove(to view: SKView) {
        
        view.allowsTransparency = true
        view.backgroundColor = .clear
        backgroundColor = .clear
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let texture = SKTexture(imageNamed: "edamame")
        
        bean = SKSpriteNode(texture: texture)
        bean.setScale(0.85)
        bean.position = CGPoint(x: size.width * 3 / 4,
                                y: size.height / 2.6)
        
        let mentortexture = SKTexture(imageNamed: "mentor-sprout")
        mentor = SKSpriteNode(texture: mentortexture)
        mentor.setScale(0.2)
        mentor.position = CGPoint(x: size.width / 3,
                                  y: size.height / 2.6)
        
        addChild(bean)
        addChild(mentor)
    }
    
    func spin() {
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
        let bounceUp = SKAction.moveBy(x: 0, y: 20, duration: 0.12)
        bounceUp.timingMode = .easeOut

        let bounceDown = SKAction.moveBy(x: 0, y: -20, duration: 0.16)
        bounceDown.timingMode = .easeIn

        let bounce = SKAction.sequence([bounceUp, bounceDown])
        bean.run(bounce)
    }
    
    func beanTalk() {
        let textures = [
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
        let textures = [
            SKTexture(imageNamed: "mentor-talk-1"),
            SKTexture(imageNamed: "mentor-talk-2"),
            SKTexture(imageNamed: "mentor-talk-3"),
            SKTexture(imageNamed: "mentor-talk-2"),
            SKTexture(imageNamed: "mentor-talk-1"),
        ]
        
        let talk = SKAction.animate(with: textures, timePerFrame: 0.08)
        bean.run(talk)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)

            if bean.contains(location) {
                spin()
            }
        }
}

struct QuestView: View {
    let quest: Quest
    var profileId: UUID?
    @Environment(\.modelContext) private var ctx

    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 300, height: 300))
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        ZStack {
            Image(quest.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            SpriteView(scene: scene, options: [.allowsTransparency])
                .frame(width: .infinity, height: .infinity)
                .ignoresSafeArea()
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    advanceStep()
                }

            }
        }
    
    func advanceStep() {
//        TODO
    }
}
    


#Preview {
    QuestView(quest: .preview)
}
