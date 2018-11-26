//
//  GameScene.swift
//  platformer
//
//  Created by 90305539 on 11/19/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import SpriteKit
import GameplayKit

/**
 Scene for level one
 */
class SceneOne: SKScene {
    
    let Player = SKSpriteNode(imageNamed: "guy")
    
    override func didMove(to view: SKView) {
        
        //TODO: initialize the level assets: BG, player, platforms, etc.
        view.presentScene(SKScene(fileNamed: "SceneOne"))
        print("lll")
        let spawn = scene?.childNode(withName: "Spawn?")
        print(spawn?.position as Any)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scene?.camera?.position = Player.position
    }
}
