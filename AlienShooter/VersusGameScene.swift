//
//  VersusGameScene.swift
//  AlienShooter
//
//  Created by Sateek Roy on 2018-02-05.
//  Copyright © 2018 SateekLambton. All rights reserved.
//

import SpriteKit
import GameplayKit

class VersusGameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var player2: SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var scoreLabel2: SKLabelNode!
    
    var timeLabel: SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var score2:Int = 0 {
        didSet {
            scoreLabel2.text = "Score: \(score2)"
        }
    }
    
    var time:Int = 60 {
        didSet {
            if time <= 5 {
                timeLabel.color = UIColor.red
            }
            timeLabel.text = "  Time\n\(time)"
        }
    }
    
    var gameTimer: Timer!
    var possibleAliens = ["alien", "alien2", "alien3"]
    
    let alienCategory: UInt32 = 0x1 << 1
    let photonTorpedoCategory: UInt32 = 0x1 << 0
    
    override func didMove(to view: SKView) {
        
        player = SKSpriteNode(imageNamed: "shuttle")
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: 30, y: frame.size.height / 2)
        
        player2 = SKSpriteNode(imageNamed: "shuttle2")
        player2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player2.position = CGPoint(x: self.frame.width - 35, y: frame.size.height / 2)
        
        self.addChild(player)
        self.addChild(player2)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        scoreLabel2 = SKLabelNode(text: "Score: 0")
        scoreLabel2.position = CGPoint(x: self.frame.size.height - 20, y: self.frame.size.height - 60)
        scoreLabel2.fontName = "AmericanTypewriter-Bold"
        scoreLabel2.fontSize = 36
        scoreLabel2.fontColor = UIColor.white
        score2 = 0
        addChild(scoreLabel2)
        
        timeLabel = SKLabelNode(text: "  Time\n60")
        timeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 60)
        timeLabel.fontName = "AmericanTypewriter-Bold"
        timeLabel.fontSize = 36
        timeLabel.fontColor = UIColor.white
        time = GameTimer.timer
        
        self.addChild(scoreLabel)
        self.addChild(timeLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.47, target: self, selector: #selector(fireTorpedo), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func decrementTimer() {
        time -= 1
    }
    
    @objc func addAlien() {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 100, highestValue: Int(self.frame.size.width) - 100)
        
        
        let position = CGFloat(randomAlienPosition.nextInt())
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        alien.name = "Alien"
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 5
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        alien.run(SKAction.sequence(actionArray))
    }
    
    @objc func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        let torpedoNode2 = SKSpriteNode(imageNamed: "torpedo2")
        torpedoNode.position = player.position
        torpedoNode.position.x += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        torpedoNode.name = "Torpedo1"
        
        torpedoNode2.position = player2.position
        torpedoNode2.position.x += 5
        torpedoNode2.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode2.size.width / 2)
        torpedoNode2.physicsBody?.isDynamic = true
        torpedoNode2.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode2.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode2.physicsBody?.collisionBitMask = 0
        torpedoNode2.physicsBody?.usesPreciseCollisionDetection = true
        torpedoNode2.name = "Torpedo2"
        
        self.addChild(torpedoNode)
        self.addChild(torpedoNode2)
        
        let animationDuration:TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width + 10, y: player.position.y), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
        
        var actionArray2 = [SKAction]()
        actionArray2.append(SKAction.move(to: CGPoint(x: 10, y: player2.position.y), duration: animationDuration))
        actionArray2.append(SKAction.removeFromParent())
        torpedoNode2.run(SKAction.sequence(actionArray2))
        //torpedoNode.run(SKAction.sequence(actionArray), withKey: "TorpedoFire")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < self.frame.midX {
                player.position.y = location.y
            } else {
                player2.position.y = location.y
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
//        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
//            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
//        }
        
        if firstBody.node?.name == "Torpedo1" && secondBody.node?.name == "Alien" {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode, torpedoName: "Torpedo1")
            
        } else if firstBody.node?.name == "Torpedo2" && secondBody.node?.name == "Alien" {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode, torpedoName: "Torpedo2")
            
        }
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode, torpedoName: String) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        if (torpedoName == "Torpedo1") {
            score += 1
        } else {
            score2 += 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if time < 1 {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene:SKScene = GameOverScene(size: self.size, score1: score, score2: score2)
            self.view?.presentScene(scene, transition: transition)
        }
    }
}
