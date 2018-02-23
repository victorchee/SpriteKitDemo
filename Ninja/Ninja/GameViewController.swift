//
//  GameViewController.swift
//  Ninja
//
//  Created by Migu on 2018/2/23.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true

            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
        }
        
        startBackgroundMusic()
    }
    
    private func startBackgroundMusic() {
        if let path = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            audioPlayer = try! AVAudioPlayer(contentsOf: path, fileTypeHint: "mp3")
            if let player = audioPlayer {
                player.prepareToPlay()
                player.numberOfLoops = -1
                player.play()
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
