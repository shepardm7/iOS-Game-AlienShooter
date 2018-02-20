//
//  GameOverScene.swift
//  AlienShooter
//
//  Created by Sateek Roy on 2018-02-05.
//  Copyright © 2018 SateekLambton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var gameOverLabel: SKLabelNode!
    var score1Label: SKLabelNode!
    var score2Label: SKLabelNode!
    var winnerLabel: SKLabelNode!
    var playAgainButton: SKSpriteNode!
    var mainMenuButton: SKSpriteNode!
    var score = 0
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        self.score = score
        
        winnerLabel = SKLabelNode(text: "You scored \(score)")
        winnerLabel.fontColor = UIColor.white
        
        playAgainButton = SKSpriteNode(imageNamed: "playAgainButton")
        playAgainButton.position = CGPoint(x: self.frame.midX - 160, y: self.frame.size.height - 440)
        
        mainMenuButton = SKSpriteNode(imageNamed: "mainMenuButton")
        mainMenuButton.position = CGPoint(x: self.frame.midX + 160, y: self.frame.size.height - 440)
        
    }
    
    init(size: CGSize, score1: Int, score2: Int) {
        super.init(size: size)
        
        if (score1 > score2) {
            winnerLabel = SKLabelNode(text: "Player 1 Wins!")
            winnerLabel.fontColor = UIColor.red
        } else if score1 < score2 {
            winnerLabel = SKLabelNode(text: "Player 2 Wins!")
            winnerLabel.fontColor = UIColor.blue
        } else {
            winnerLabel = SKLabelNode(text: "Tie!")
            winnerLabel.fontColor = UIColor.white
        }
        
        score1Label = SKLabelNode(text: "\(score1)")
        score1Label.position = CGPoint(x: self.frame.midX - 100, y: self.frame.size.height - 440)
        score1Label.fontName = "AmericanTypewriter-Bold"
        score1Label.fontSize = 90
        score1Label.fontColor = UIColor.red
        
        score2Label = SKLabelNode(text: "\(score2)")
        score2Label.position = CGPoint(x: self.frame.midX + 100, y: self.frame.size.height - 440)
        score2Label.fontName = "AmericanTypewriter-Bold"
        score2Label.fontSize = 90
        score2Label.fontColor = UIColor.blue
        
        playAgainButton = SKSpriteNode(imageNamed: "playAgainButton")
        playAgainButton.position = CGPoint(x: self.frame.midX - 160, y: self.frame.size.height - 500)
        
        mainMenuButton = SKSpriteNode(imageNamed: "mainMenuButton")
        mainMenuButton.position = CGPoint(x: self.frame.midX + 160, y: self.frame.size.height - 500)
        
        addChild(score1Label)
        addChild(score2Label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 250)
        gameOverLabel.fontName = "AmericanTypewriter-Bold"
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.fontSize = 130
        
        
        winnerLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 350)
        winnerLabel.fontName = "AmericanTypewriter-Bold"
        winnerLabel.fontSize = 90
        
        
        playAgainButton.size = CGSize(width: 300, height: 80)
        
        
        mainMenuButton.size = CGSize(width: 300, height: 80)
        
        addChild(gameOverLabel)
        addChild(winnerLabel)
        addChild(playAgainButton)
        addChild(mainMenuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playAgainButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                var scene:SKScene
                if score1Label == nil && score2Label == nil {
                    scene = GameScene(size: self.size)
                } else {
                    scene = VersusGameScene(size: self.size)
                }
                self.view?.presentScene(scene, transition: transition)
            } else if node == mainMenuButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = MainMenu(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
