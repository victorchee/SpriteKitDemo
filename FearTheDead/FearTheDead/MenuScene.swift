//
//  MenuScene.swift
//  FearTheDead
//
//  Created by Migu on 2018/2/23.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var didWin: Bool
    
    init(size: CGSize, didWin: Bool) {
        self.didWin = didWin
        super.init(size: size)
        scaleMode = .fill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(white: 0, alpha: 1)
        
        let winLabel = SKLabelNode(text: didWin ? "YOU WON!" : "YOU LOST :[")
        winLabel.fontName = "AvenirNext-Bold"
        winLabel.fontSize = 65
        winLabel.fontColor = .white
        winLabel.position = CGPoint(x: frame.midX, y: frame.midY * 1.5)
        addChild(winLabel)
        
        let label = SKLabelNode(text: "Press anywhere to play again!")
        label.fontName = "AVenirNext-Bold"
        label.fontSize = 55
        label.fontColor = .white
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(label)
        
        run(SKAction.playSoundFileNamed(didWin ? "fear_win.mp3" : "fear_lose.mp3", waitForCompletion: false))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene not found")
        }
        let transition = SKTransition.flipVertical(withDuration: 1)
        gameScene.scaleMode = .fill
        view?.presentScene(gameScene, transition: transition)
    }
}
