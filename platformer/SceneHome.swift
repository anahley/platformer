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
        
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.45)
        addChild(button)
        
    }
    
    func initParticles() {
        
        let randomX = drand48() * Double(size.width)
        
        let particle = SKSpriteNode(color:SKColor.white, size: CGSize(width: size.width * 0.015, height: size.height * 0.015))
        
        particle.zPosition = -1
        
        let fall = SKAction.move(to: CGPoint(x: randomX, y: Double(0 - particle.size.height/2)), duration: 4)
        
        particle.position = CGPoint(x: randomX, y: Double(size.height + particle.size.height/2))
        
        let fallDone = SKAction.removeFromParent()
        
        addChild(particle)
        
        print(particle.position)
        
        particle.run(SKAction.sequence([fall, fallDone]))
        
    }
    
    func addTitle () {
        
        gameTitle.text = "OBLIVION"
        gameTitle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        gameTitle.fontSize = 0.1 * size.width
        gameTitle.fontColor = SKColor.white
        addChild(gameTitle)
        
    }
    
    override func didMove(to view: SKView) {
        
        createButton()
        
        addTitle()
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(initParticles), SKAction.wait(forDuration: 0.3)])))
        
        self.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.0, alpha: 1)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        print(touchLocation)
        
        //check if touch is within button range
        if(button.contains(touchLocation)){
            //it is!!!!
            //change scene to game (SceneOne)
            if let scene = SKScene(fileNamed:"SceneOne") {
                //setup your scene here
                view!.presentScene(scene)
            }
        } else {
            //ignore
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
