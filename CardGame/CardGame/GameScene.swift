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
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.position = CGPoint.zero
        addChild(backgroundNode)
    }
}
