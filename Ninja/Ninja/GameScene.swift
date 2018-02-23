//
//  GameScene.swift
//  Ninja
//
//  Created by Migu on 2018/2/23.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var score = 0
    var life = 3
    
    let scoreLabel = SKLabelNode()
    let livesLabel = SKLabelNode()
    
    var shadow: SKNode!
    var lowerTorso: SKNode!
    var upperTorso: SKNode!
    
    var head: SKNode!
    let targetNode = SKNode()
    var firstTouch = false
    
    var upperArmFront: SKNode!
    var lowerArmFront: SKNode!
    var fistFront: SKNode!
    
    var upperArmBack: SKNode!
    var lowerArmBack: SKNode!
    var fistBack: SKNode!
    
    let upperArmAngleDegree: CGFloat = -10
    let lowerArmAngleDegree: CGFloat = 130
    var rightPunch = true
    
    var upperLeg: SKNode!
    var lowerLeg: SKNode!
    var foot: SKNode!
    
    let upperLegAngleDegree: CGFloat = 22
    let lowerLegAngleDegree: CGFloat = -30
    
    var lastSpawnTimeInterval: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 10, y: size.height - 10)
        addChild(scoreLabel)
        
        livesLabel.fontName = "Chalkduster"
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 20
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.verticalAlignmentMode = .top
        livesLabel.position = CGPoint(x: size.width - 10, y: size.height - 10)
        addChild(livesLabel)
        
        shadow = childNode(withName: "shadow")
        shadow.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        
        lowerTorso = childNode(withName: "torso_lower")
        lowerTorso.position = CGPoint(x: frame.midX, y: frame.midY - 30)
        upperTorso = lowerTorso.childNode(withName: "torso_upper")
        
        head = upperTorso.childNode(withName: "head")
        let orientToNodeConstraint = SKConstraint.orient(to: targetNode, offset: SKRange(constantValue: 0))
        let range = SKRange(lowerLimit: CGFloat(-50).degreesToRadians(), upperLimit: CGFloat(80).degreesToRadians())
        let rotationConstraint = SKConstraint.zRotation(range)
        rotationConstraint.enabled = false
        orientToNodeConstraint.enabled = false
        head.constraints = [orientToNodeConstraint, rotationConstraint]
        
        upperArmFront = upperTorso.childNode(withName: "arm_upper_front")
        lowerArmFront = upperArmFront.childNode(withName: "arm_lower_front")
        fistFront = lowerArmFront.childNode(withName: "fist_front")
        
        upperArmBack = upperTorso.childNode(withName: "arm_upper_back")
        lowerArmBack = upperArmBack.childNode(withName: "arm_lower_back")
        fistBack = lowerArmBack.childNode(withName: "fist_back")
        
        upperLeg = lowerTorso.childNode(withName: "leg_upper_back")
        lowerLeg = upperLeg.childNode(withName: "leg_lower_back")
        foot = lowerLeg.childNode(withName: "foot_back")
        lowerLeg.reachConstraints = SKReachConstraints(lowerAngleLimit: CGFloat(-45).degreesToRadians(), upperAngleLimit: 0)
        upperLeg.reachConstraints = SKReachConstraints(lowerAngleLimit: CGFloat(-45).degreesToRadians(), upperAngleLimit: CGFloat(160).degreesToRadians())
    }
    
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLast = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeSinceLast > 1.0 {
            timeSinceLast = 1.0 / 60.0
            lastUpdateTimeInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLast: timeSinceLast)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !firstTouch {
            for constraint in head.constraints! {
                constraint.enabled = true
            }
            firstTouch = true
        }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lowerTorso.xScale = location.x < frame.midX ? abs(lowerTorso.xScale) * -1 : abs(lowerTorso.xScale)
        
        let lower = location.y < lowerTorso.position.y + 10
        if lower {
            kick(at: position)
        } else {
            punch(at: location)
        }
        
        targetNode.position = location
    }
    
    func punch(at location: CGPoint) {
        if rightPunch {
            punch(at: location, upperArmNode: upperArmFront, lowerArmNode: lowerArmFront, fistNode: fistFront)
        } else {
            punch(at: location, upperArmNode: upperArmBack, lowerArmNode: lowerArmBack, fistNode: fistBack)
        }
        rightPunch = !rightPunch
    }
    
    private func punch(at location: CGPoint, upperArmNode: SKNode, lowerArmNode: SKNode, fistNode: SKNode) {
        let punch = SKAction.reach(to: location, rootNode: upperArmNode, duration: 0.1)
        let checkIntersection = intersectionCheckAction(for: fistNode)
        let restore = SKAction.run {
            upperArmNode.run(SKAction.rotate(toAngle: self.upperArmAngleDegree.degreesToRadians(), duration: 0.1))
            lowerArmNode.run(SKAction.rotate(toAngle: self.lowerArmAngleDegree.degreesToRadians(), duration: 0.1))
        }
        fistNode.run(SKAction.sequence([punch, checkIntersection, restore]))
    }
    
    func kick(at location: CGPoint) {
        let kick = SKAction.reach(to: location, rootNode: upperLeg, duration: 0.1)
        let checkIntersection = intersectionCheckAction(for: foot)
        let restore = SKAction.run {
            self.upperLeg.run(SKAction.rotate(toAngle: self.upperLegAngleDegree.degreesToRadians(), duration: 0.1))
            self.lowerLeg.run(SKAction.rotate(toAngle: self.lowerLegAngleDegree.degreesToRadians(), duration: 0.1))
        }
        foot.run(SKAction.sequence([kick, checkIntersection, restore]))
    }
    
    func addShuriken() {
        let shuriken = SKSpriteNode(imageNamed: "projectile")
        let minY = lowerTorso.position.y - 60 + shuriken.size.height / 2
        let maxY = lowerTorso.position.y + 140 - shuriken.size.height / 2
        let actualY = CGFloat(arc4random()).truncatingRemainder(dividingBy: maxY - minY) + minY
        
        let left = arc4random() % 2
        let actualX = left == 0 ? -shuriken.size.width / 2 : size.width + shuriken.size.width / 2
        
        shuriken.position = CGPoint(x: actualX, y: actualY)
        shuriken.name = "shuriken"
        shuriken.zPosition = 1
        addChild(shuriken)
        
        let minDuration = 4.0
        let maxDuration = 6.0
        let actualDuration = Double(arc4random()).truncatingRemainder(dividingBy: maxDuration - minDuration) + minDuration
        
        let actionMove = SKAction.move(to: CGPoint(x: size.width / 2, y: actualY), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        let hitAction = SKAction.run {
            if self.life > 0 {
                self.life -= 1
            }
            self.livesLabel.text = "Lives: \(Int(self.life))"
            
            let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.05), SKAction.fadeIn(withDuration: 0.05)])
            let checkGameOverAction = SKAction.run {
                if self.life <= 0 {
                    let transition = SKTransition.fade(withDuration: 1)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: transition)
                }
            }
            
            self.lowerTorso.run(SKAction.sequence([blink, blink, checkGameOverAction]))
        }
        shuriken.run(SKAction.sequence([actionMove, hitAction, actionMoveDone]))
        
        let angle = left == 0 ? CGFloat(-90).degreesToRadians() : CGFloat(90).degreesToRadians()
        let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: angle, duration: 0.2))
        shuriken.run(SKAction.repeatForever(rotate))
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLast: TimeInterval) {
        lastSpawnTimeInterval = timeSinceLast + lastSpawnTimeInterval
        if lastSpawnTimeInterval > 0.75 {
            lastSpawnTimeInterval = 0
            addShuriken()
        }
    }
    
    func intersectionCheckAction(for effectorNode: SKNode) -> SKAction {
        let checkIntersection = SKAction.run {
            for object in self.children {
                if let node = object as? SKSpriteNode, node.name == "shuriken" {
                    let effectorInNode = self.convert(effectorNode.position, from: effectorNode.parent!)
                    var shurikenFrame = node.frame
                    shurikenFrame.origin = self.convert(shurikenFrame.origin, from: node.parent!)
                    
                    if shurikenFrame.contains(effectorInNode) {
                        // Hit
                        self.run(SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false))
                        
                        let spark = SKSpriteNode(imageNamed: "spark")
                        spark.position = node.position
                        spark.zPosition = 60
                        self.addChild(spark)
                        
                        let fadeAndScaleAction = SKAction.group([SKAction.fadeOut(withDuration: 0.2), SKAction.scale(to: 0.1, duration: 0.2)])
                        let cleanupAction = SKAction.removeFromParent()
                        spark.run(SKAction.sequence([fadeAndScaleAction, cleanupAction]))
                        
                        self.score += 1
                        self.scoreLabel.text = "Score: \(Int(self.score))"
                        node.removeFromParent()
                    } else {
                        // Miss
                        self.run(SKAction.playSoundFileNamed("miss.mp3", waitForCompletion: false))
                    }
                }
            }
        }
        return checkIntersection
    }
}
