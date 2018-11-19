//
//  File.swift
//  platformer
//
//  Created by 90302556 on 11/19/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import SpriteKit
import GameplayKit

class SceneHome: SKScene {
    
    var button: SKNode! = nil
    
    func createButton() {
        
        button = SKSpriteNode(imageNamed: "")
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(button)
        
    }
    
    override func didMove(to view: SKView) {
        
        createButton()
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
