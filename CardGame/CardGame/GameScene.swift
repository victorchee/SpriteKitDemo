//
//  GameScene.swift
//  CardGame
//
//  Created by Migu on 2018/2/22.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let backgroundNode = SKSpriteNode(imageNamed: "bg_blank")
        backgroundNode.size = size
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.position = CGPoint.zero
        addChild(backgroundNode)
        
        let wolfNode = Card(cardType: .wolf)
        wolfNode.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(wolfNode)
        
        let bearNode = Card(cardType: .bear)
        bearNode.position = CGPoint(x: size.width * 0.9, y: size.height * 0.5)
        addChild(bearNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let card = atPoint(location) as? Card else { return }
        card.zPosition = CardLevel.moving.rawValue
        
        if touch.tapCount > 1 {
            card.enlarge()
            return
        }
        if card.enlarged { return }
        
        let rotateRight = SKAction.rotate(byAngle: 0.15, duration: 0.2)
        let rotateLeft = SKAction.rotate(byAngle: -0.15, duration: 0.2)
        let cycle = SKAction.sequence([rotateRight, rotateLeft, rotateLeft, rotateRight])
        card.run(SKAction.repeatForever(cycle), withKey: "wiggle")
        
        card.removeAction(forKey: "drop")
        card.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let card = atPoint(location) as? Card else { return }
        if card.enlarged { return }
        card.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let card = atPoint(location) as? Card else { return }
        if card.enlarged { return }
        card.zPosition = CardLevel.board.rawValue
        
        card.removeAction(forKey: "wiggle")
        card.run(SKAction.rotate(byAngle: 0, duration: 0.2), withKey: "rotate")
        
        card.removeAction(forKey: "pickup")
        card.run(SKAction.scale(to: 1, duration: 0.25), withKey: "drop")
        
        card.removeFromParent()
        addChild(card)
    }
}
