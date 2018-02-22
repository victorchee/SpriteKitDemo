//
//  GameOverScene.swift
//  SpriteKitDemo
//
//  Created by Migu on 2018/2/22.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = won ? "YOU WON!" : "YOU LOSE :["
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
        
        run(SKAction.sequence([SKAction.wait(forDuration: 3),
                               SKAction.run {
                                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                                let scene = GameScene(size: size)
                                self.view?.presentScene(scene, transition: reveal)
            }]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
