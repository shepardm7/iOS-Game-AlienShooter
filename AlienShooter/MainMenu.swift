//
//  MainMenu.swift
//  AlienShooter
//
//  Created by Sateek Roy on 2018-02-05.
//  Copyright © 2018 SateekLambton. All rights reserved.
//

import Foundation
import SpriteKit
class MainMenu: SKScene {
    
    
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "playButton")
    
    
    var vsButton = SKSpriteNode()
    let vsButtonTex = SKTexture(imageNamed: "versusButton")
    
    var setTimeButton = SKSpriteNode()
    let setTimeButtonTex = SKTexture(imageNamed: "setTimerButton")
    
    var quitButton = SKSpriteNode()
    let quitButtonTex = SKTexture(imageNamed: "quitButton")
    
    
    override func didMove(to view: SKView) {
        
        
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY + 120)
        playButton.size = CGSize(width: 300, height: 80)
        self.addChild(playButton)
        
        vsButton = SKSpriteNode(texture: vsButtonTex)
        vsButton.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        vsButton.size = CGSize(width: 300, height: 80)
        self.addChild(vsButton)
        
        setTimeButton = SKSpriteNode(texture: setTimeButtonTex)
        setTimeButton.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        setTimeButton.size = CGSize(width: 300, height: 80)
        self.addChild(setTimeButton)
        
        quitButton = SKSpriteNode(texture: quitButtonTex)
        quitButton.position = CGPoint(x: frame.midX, y: frame.midY - 120)
        quitButton.size = CGSize(width: 300, height: 80)
        self.addChild(quitButton)
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
                
            } else if node == vsButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = VersusGameScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            } else if node == quitButton {
                exit(0)
            } else if node == setTimeButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                let scene:SKScene = SetTimerScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
