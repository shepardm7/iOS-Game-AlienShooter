//
//  SetTimerScene.swift
//  AlienShooter
//
//  Created by Sateek Roy on 2018-02-05.
//  Copyright © 2018 SateekLambton. All rights reserved.
//

import SpriteKit
import GameplayKit

class SetTimerScene: SKScene {
    
    var timeDisplay: SKLabelNode!
    var addButton: SKSpriteNode!
    var subButton: SKSpriteNode!
    var saveButton: SKSpriteNode!
    var cancelButton: SKSpriteNode!
    var time: Int = GameTimer.timer
    
    override func didMove(to view: SKView) {
        timeDisplay = SKLabelNode(text: "\(time)")
        timeDisplay.fontName = "AmericanTypewriter-Bold"
        timeDisplay.fontSize = 100
        timeDisplay.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        addButton = SKSpriteNode(imageNamed: "plusButton")
        addButton.size = CGSize(width: 30, height: 30)
        addButton.position = CGPoint(x: self.frame.midX - 30, y: self.frame.midY - 50)
        
        subButton = SKSpriteNode(imageNamed: "minusButton")
        subButton.size = CGSize(width: 30, height: 30)
        subButton.position = CGPoint(x: self.frame.midX + 30, y: self.frame.midY - 50)
        
        saveButton = SKSpriteNode(imageNamed: "saveButton")
        saveButton.size = CGSize(width: 300, height: 80)
        saveButton.anchorPoint = CGPoint(x: 1, y: 0.5)
        saveButton.position = CGPoint(x: self.frame.midX - 20, y: self.frame.midY - 200)
        
        cancelButton = SKSpriteNode(imageNamed: "cancelButton")
        cancelButton.size = CGSize(width: 300, height: 80)
        cancelButton.anchorPoint = CGPoint(x: 0, y: 0.5)
        cancelButton.position = CGPoint(x: self.frame.midX + 20, y: self.frame.midY - 200)
        
        
        addChild(timeDisplay)
        addChild(addButton)
        addChild(subButton)
        addChild(saveButton)
        addChild(cancelButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == addButton {
                if time < 120 {
                    time += 5
                    timeDisplay.text = "\(time)"
                }
            } else if node == subButton {
                if time > 5 {
                    time -= 5
                    timeDisplay.text = "\(time)"
                }
            } else if node == saveButton {
                GameTimer.timer = time
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = MainMenu(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            } else if node == cancelButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = MainMenu(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
