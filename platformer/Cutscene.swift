//
//  Cutscene.swift
//  platformer
//
//  Created by 90305539 on 12/21/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import Foundation
import SpriteKit

class Cutscene: SKScene {
    
    override func didMove(to view: SKView) {
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(initParticles), SKAction.wait(forDuration: 0.15)])))
        
    }
    
    func initParticles() {
        
        let randomX = drand48() * Double(size.width)
        
        let particle = SKSpriteNode(color:SKColor.white, size: CGSize(width: size.width * 0.015, height: size.height * 0.015))
        
        particle.zPosition = -1
        
        let fall = SKAction.move(to: CGPoint(x: randomX, y: Double(0 - particle.size.height/2)), duration: 4)
        
        particle.position = CGPoint(x: randomX, y: Double(size.height + particle.size.height/2))
        
        let fallDone = SKAction.removeFromParent()
        
        addChild(particle)
        
        
        particle.run(SKAction.sequence([fall, fallDone]))
        
    }

}
