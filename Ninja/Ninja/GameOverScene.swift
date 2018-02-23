//
//  GameOverScene.swift
//  Ninja
//
//  Created by Migu on 2018/2/23.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        let lable = SKLabelNode(fontNamed: "Chalkduster")
        lable.text = "Game Over"
        lable.fontSize = 65
        lable.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(lable)
        
        run(SKAction.sequence([SKAction.wait(forDuration: 1),
                               SKAction.run {
                                let transition = SKTransition.fade(withDuration: 1)
                                let scene = GameScene(fileNamed: "GameScene")!
                                scene.scaleMode = .aspectFill
                                scene.size = self.size
                                self.view?.presentScene(scene, transition: transition)
            }]))
    }
}
