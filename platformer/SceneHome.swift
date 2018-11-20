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
    let gameTitle = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    func createButton() {
        
        button = SKSpriteNode(imageNamed: "playButton")
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(button)
        
        
    }
    
    func addTitle () {
        
        gameTitle.text = "Hello"
        gameTitle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        gameTitle.fontSize = 60
        
        
    }
    
    override func didMove(to view: SKView) {
        
        createButton()
        addTitle()
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
