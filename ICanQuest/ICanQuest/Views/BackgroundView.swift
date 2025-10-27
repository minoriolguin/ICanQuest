//
//  BackgroundView.swift
//  ICanQuest
//
//  Created by Minori Olguin on 2025-10-07.
//

import SwiftUI
import AVFoundation
import UIKit

final class VideoBackgroundView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

struct BackgroundView: UIViewRepresentable {
    let filename: String
    let fileExtension: String = "mp4"
    
    final class Coordinator {
        var looper: AVPlayerLooper?
        var queuePlayer: AVQueuePlayer?
    }
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> VideoBackgroundView {
        let view = VideoBackgroundView()
        view.playerLayer.videoGravity = .resizeAspectFill 

        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Unable to access media")
            return view
        }

        let asset = AVURLAsset(url: url)
        let item  = AVPlayerItem(asset: asset)

        let player = AVQueuePlayer(items: [])
        player.isMuted = true
        player.actionAtItemEnd = .none

        context.coordinator.queuePlayer = player
        context.coordinator.looper = AVPlayerLooper(player: player, templateItem: item)

        view.playerLayer.player = player
        player.play()

        return view
    }

    func updateUIView(_ uiView: VideoBackgroundView, context: Context) {}

    static func dismantleUIView(_ uiView: VideoBackgroundView, coordinator: Coordinator) {
        coordinator.queuePlayer?.pause()
        coordinator.queuePlayer = nil
        coordinator.looper = nil
    }
}
