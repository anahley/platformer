//
//  SceneOne.swift
//  platformer
//
//  Created by 90305539 on 11/27/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import Foundation
//
//  GameScene.swift
//  SceneOne.swift
//  platformer
//
//  Created by 90305539 on 11/19/18.
//  Created by 90305539 on 11/27/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

/**
 Scene for level one
 */
class SceneOne: SKScene {
    
    let Player = SKSpriteNode(imageNamed: "guy")
    
    override func didMove(to view: SKView) {
        
        print("ndfjsk")
        //TODO: initialize the level assets: BG, player, platforms, etc.
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scene?.camera?.position = Player.position
    }
}
