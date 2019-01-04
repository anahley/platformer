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
        run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
            view.presentScene(SKScene(fileNamed: "SceneOne")!, transition: SKTransition.fade(withDuration: 2))
            }]))
    }
    
    func initParticles() {
        
        let randomX = drand48() * Double(size.width)
        
        let particle = SKSpriteNode(color:SKColor.white, size: CGSize(width: size.width * 0.015, height: size.height * 0.015))
        
        particle.zPosition = 6
        
        let fall = SKAction.move(to: CGPoint(x: randomX-(Double(size.width)/2), y: Double(size.height / -2)), duration: 3)
        
        particle.position = CGPoint(x: randomX-(Double(size.width)/2), y: Double(size.height/2 + particle.size.height/2))
        
        let fallDone = SKAction.removeFromParent()
        
        addChild(particle)
        
        
        particle.run(SKAction.sequence([fall, fallDone]))
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view!.presentScene(SKScene(fileNamed: "SceneOne")!, transition: SKTransition.fade(withDuration: 2))
    }
}
