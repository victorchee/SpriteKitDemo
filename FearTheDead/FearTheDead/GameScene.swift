//
//  GameScene.swift
//  FearTheDead
//
//  Created by Migu on 2018/2/23.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playerSpeed: CGFloat = 150
    let zombieSpeed: CGFloat = 75
    
    var goal: SKSpriteNode?
    var player: SKSpriteNode?
    var zombies: [SKSpriteNode] = []
    
    var lastTouch: CGPoint? = nil
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        player = childNode(withName: "player") as? SKSpriteNode
        listener = player
        for child in self.children {
            if child.name == "zombie" {
                if let child = child as? SKSpriteNode {
                    let audioNode = SKAudioNode(fileNamed: "fear_moan.wav")
                    child.addChild(audioNode)
                    
                    zombies.append(child)
                }
            }
        }
        goal = childNode(withName: "goal") as? SKSpriteNode
        
        updateCamera()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func didSimulatePhysics() {
        if player != nil {
            updatePlayer()
            updateZombies()
        }
    }
    
    private func updateCamera() {
        guard let player = player else { return }
        camera?.position = player.position
    }
    
    private func handleTouches(_ touches: Set<UITouch>) {
        lastTouch = touches.first?.location(in: self)
    }
    
    private func updatePlayer() {
        guard let player = player, let touch = lastTouch else {
            return
        }
        let currentPosition = player.position
        if shoudMove(currentPosition: currentPosition, touchPosition: touch) {
            updatePosition(for: player, to: touch, speed: playerSpeed)
            updateCamera()
        } else {
            player.physicsBody?.isResting = true
        }
    }
    
    private func shoudMove(currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        guard let player = player else { return false }
        return abs(currentPosition.x - touchPosition.x) > player.frame.width / 2 || abs(currentPosition.y - touchPosition.y) > player.frame.height / 2
    }
    
    private func updatePosition(for sprite: SKSpriteNode, to target: CGPoint, speed: CGFloat) {
        let currentPosition = sprite.position
        let angle = CGFloat.pi + atan2(currentPosition.y - target.y, currentPosition.x - target.x)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat.pi * 0.5, duration: 0)
        sprite.run(rotateAction)
        
        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)
        sprite.physicsBody?.velocity = CGVector(dx: velocityX, dy: velocityY)
    }
    
    private func updateZombies() {
        guard let player = player else { return }
        let targetPosition = player.position
        for zombie in zombies {
            updatePosition(for: zombie, to: targetPosition, speed: zombieSpeed)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask && secondBody.categoryBitMask == zombies.first?.physicsBody?.categoryBitMask {
            gameOver(false)
        } else if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask && secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
            gameOver(true)
        }
    }
    
    private func gameOver(_ didWin: Bool) {
        let menuScene = MenuScene(size: size, didWin: didWin)
        let transition = SKTransition.flipVertical(withDuration: 1)
        view?.presentScene(menuScene, transition: transition)
    }
}
