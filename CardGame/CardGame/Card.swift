//
//  Card.swift
//  CardGame
//
//  Created by Migu on 2018/2/22.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

enum CardType: Int {
    case wolf, bear, dragon
}

enum CardLevel: CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 200
}

class Card: SKSpriteNode {
    let cardType: CardType
    let frontTexture: SKTexture
    let backTexture: SKTexture
    let largeTextureFilename: String
    var largeTexture: SKTexture?
    var damage = 0
    let damageLabel: SKLabelNode
    var faceUp = true
    var enlarged = false
    var savedPosition = CGPoint.zero
    
    init(cardType: CardType) {
        self.cardType = cardType
        
        backTexture = SKTexture(imageNamed: "card_back")
        
        switch cardType {
        case .wolf:
            frontTexture = SKTexture(imageNamed: "card_creature_wolf")
            largeTextureFilename = "card_creature_wolf_large"
        case .bear:
            frontTexture = SKTexture(imageNamed: "card_creature_bear")
            largeTextureFilename = "card_creature_bear_large"
        case .dragon:
            frontTexture = SKTexture(imageNamed: "card_creature_dragon")
            largeTextureFilename = "card_creature_dragon_large"
        }
        
        damageLabel = SKLabelNode(fontNamed: "Helvetica")
        damageLabel.name = "damageLabel"
        damageLabel.fontSize = 12
        damageLabel.fontColor = SKColor(red: 0.47, green: 0, blue: 0, alpha: 1)
        damageLabel.text = "0"
        damageLabel.position = CGPoint(x: 25, y: 40)
        
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
        addChild(damageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip() {
        let firstHalfFlip = SKAction.scaleX(to: 0, duration: 0.4)
        let secondHalfFlip = SKAction.scaleX(to: 1, duration: 0.4)
        setScale(1)
        
        if faceUp {
            run(firstHalfFlip) {
                self.texture = self.backTexture
                self.damageLabel.isHidden = true
                self.run(secondHalfFlip)
            }
        } else {
            run(firstHalfFlip) {
                self.texture = self.frontTexture
                self.damageLabel.isHidden = false
                self.run(secondHalfFlip)
            }
        }
        faceUp = !faceUp
    }
    
    func enlarge() {
        if enlarged {
            let slide = SKAction.move(to: savedPosition, duration: 0.3)
            let scaleDown = SKAction.scale(by: 1, duration: 0.3)
            run(SKAction.group([slide, scaleDown])) {
                self.enlarged = false
                self.zPosition = CardLevel.board.rawValue
            }
        } else {
            enlarged = true
            savedPosition = position
            
            if largeTexture == nil {
                largeTexture = SKTexture(imageNamed: largeTextureFilename)
            }
            texture = largeTexture
            
            zPosition = CardLevel.enlarged.rawValue
            
            if let parent = parent {
                removeAllActions()
                zRotation = 0
                let newPosition = CGPoint(x: parent.frame.minX, y: parent.frame.minY)
                let slide = SKAction.move(to: newPosition, duration: 0.3)
                let scaleUp = SKAction.scale(to: 5, duration: 0.3)
                run(SKAction.group([slide, scaleUp]))
            }
        }
    }
}
