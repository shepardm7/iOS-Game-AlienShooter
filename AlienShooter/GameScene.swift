//
//  GameScene.swift
//  AlienShooter
//
//  Created by Sateek Roy on 2018-02-05.
//  Copyright © 2018 SateekLambton. All rights reserved.
//

import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var timeLabel: SKLabelNode!
    
    var pauseButton: SKSpriteNode!
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
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
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        timeLabel = SKLabelNode(text: "  Time\n60")
        timeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 60)
        timeLabel.fontName = "AmericanTypewriter-Bold"
        timeLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        time = GameTimer.timer
        
        pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.size = CGSize(width: 40, height: 40)
        pauseButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        pauseButton.position = CGPoint(x: self.frame.midX, y: timeLabel.position.y - 5)
        
        self.addChild(scoreLabel)
        self.addChild(timeLabel)
        self.addChild(pauseButton)
        
        if self.isPaused == true {
            self.isPaused = false
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)

        //gameTimer = Timer.scheduledTimer(timeInterval: 0.47, target: self, selector: #selector(fireTorpedo), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decrementTimer), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func decrementTimer() {
        time -= 1
    }
    
    @objc func addAlien() {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 100, highestValue: Int(self.frame.size.width))
        
        
        let position = CGFloat(randomAlienPosition.nextInt())
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        let animationDuration:TimeInterval = 5
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        alien.run(SKAction.sequence(actionArray))
    }
    
//    @objc func fireTorpedo() {
//        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
//
//        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
//        torpedoNode.position = player.position
//        torpedoNode.position.x += 5
//
//        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
//        torpedoNode.physicsBody?.isDynamic = true
//        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
//        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
//        torpedoNode.physicsBody?.collisionBitMask = 0
//        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
//
//        self.addChild(torpedoNode)
//
//        let animationDuration:TimeInterval = 0.3
//
//        var actionArray = [SKAction]()
//        actionArray.append(SKAction.move(to: CGPoint(x: self.frame.size.width + 10, y: player.position.y), duration: animationDuration))
//        actionArray.append(SKAction.removeFromParent())
//        //torpedoNode.run(SKAction.sequence(actionArray))
//        torpedoNode.run(SKAction.sequence(actionArray), withKey: "TorpedoFire")
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            if node == pauseButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = PauseScene(size: self.size)
                self.scene?.isPaused = true
                //PauseScene.returnToScene = self.scene
                self.scene?.removeFromParent()
                self.removeAllActions()
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < 100 {
                player.position.y = location.y
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
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "torpedo")
        projectile.position = player.position
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
//        let offsetSprite = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: 10, height: 10))
//        offsetSprite.position = CGPoint(x: offset.x, y: offset.y)
//        addChild(offsetSprite)
//        print ("Touch Location -> x: \(touchLocation.x), y: \(touchLocation.y)")
//        print ("Player Position -> x: \(player.position.x), y: \(player.position.y)")
//        print ("Offset Position -> x: \(offset.x), y: \(offset.y)")
        
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = photonTorpedoCategory
        projectile.physicsBody?.contactTestBitMask = alienCategory
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
//        let directionSprite = SKSpriteNode(color: UIColor.green, size: CGSize(width: 10, height: 10))
//        directionSprite.position = CGPoint(x: direction.x, y: direction.y)
//        addChild(directionSprite)
//        print ("Direction Position -> x: \(direction.x), y: \(direction.y)")
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
//        print ("ShootAmount Position -> x: \(shootAmount.x), y: \(shootAmount.y)")
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
//        print ("ReadDest Position -> x: \(realDest.x), y: \(realDest.y)")
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if time < 1 {
            let transition:SKTransition = SKTransition.fade(withDuration: 1)
            let scene:SKScene = GameOverScene(size: self.size, score: score)
            self.view?.presentScene(scene, transition: transition)
        }
    }
}
