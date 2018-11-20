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
    
    var button = SKSpriteNode(imageNamed: "playButton")
    let gameTitle = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    func createButton() {
        
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(button)
        
    }
    
    func addTitle () {
        
        gameTitle.text = "Hello"
        gameTitle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        gameTitle.fontSize = 60
        addChild(gameTitle)
        
    }
    
    override func didMove(to view: SKView) {
        
        createButton()
        addTitle()
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
