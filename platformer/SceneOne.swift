//
//  SceneOne.swift
//  platformer
//
//  Created by 90305539 on 11/27/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import SpriteKit
import GameplayKit

/**
 Scene for level one
 */
class SceneOne: SKScene {
    
    var touching = false
    var Player = SKSpriteNode(imageNamed: "guy")
    
    override func didMove(to view: SKView) {
        
        Player = childNode(withName: "guy") as! SKSpriteNode
        //TODO: initialize the level assets: BG, player, platforms, etc.
    }
    
    //when a touch is detected
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard let touch = touches.first else {
            return
        }
        let tapPosition = touch.location(in: self)
        
        //IF the touch is in the bottom left quarter, JOYSTICK IS ENABLED
        if ((tapPosition.x < 0) && (tapPosition.y < 0)) {
        
            let joystick = SKSpriteNode(imageNamed: "joystickCircle")
            let handle = SKSpriteNode(imageNamed: "joystickStick")
            joystick.name = "joystickCircle"
            handle.name = "stick"
            
            
            joystick.scale(to: CGSize(width: 200, height: 200))
            handle.scale(to: CGSize(width: 50, height: 50))
            
            let INSIDE = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: ((joystick.size.width/2)-(handle.size.width/4))), to: joystick.position)
            
            handle.constraints = [INSIDE]
            //handle.position = tapPosition
            joystick.position = tapPosition
            joystick.zPosition = 9
            handle.zPosition = 10
            addChild(joystick)
            joystick.addChild(handle)
            
        }
    }
    
    //when the touch ends, remove the joystick
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
        
        //if the joy stick is active, remove it and remove any movement on Player
        if let joy = childNode(withName: "joystickCircle"){
            joy.removeFromParent()
        } //the joystick is not there, error or different touch?
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        print("moved!")
        
        
        if let joy = childNode(withName: "joystickCircle"){ //IF a joystick EXISTS
            let innerPosition = touch.location(in: joy) //IF the TOUCH is in the JOYSTICK CIRCLE
            let handle = joy.childNode(withName: "stick")
            handle?.position = innerPosition //the stick will just follow the tap
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
