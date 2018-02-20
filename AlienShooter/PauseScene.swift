//
//  PauseScene.swift
//  AlienShooter
//
//  Created by Sateek Roy on 2018-02-06.
//  Copyright © 2018 SateekLambton. All rights reserved.
//

import SpriteKit
import GameplayKit

class PauseScene: SKScene {
    
    var resumeButton: SKSpriteNode!
    
    static var returnToScene: GameScene!
    static var scaleMode: SKSceneScaleMode!
    
    override func didMove(to view: SKView) {
        resumeButton = SKSpriteNode(color: UIColor.orange, size: CGSize(width: 40, height: 40))
        resumeButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(resumeButton)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            if node == resumeButton {
                let transition:SKTransition = SKTransition.fade(withDuration: 1)
                //let scene:SKScene = GameScene(size: self.size)
                self.view?.presentScene(PauseScene.returnToScene, transition: transition)
            }
        }
        
    }
}
