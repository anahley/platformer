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
    
    var neverJoyed = true
    var haste = 100.0
    var Player = SKSpriteNode(imageNamed: "guy")
    let joystick = SKSpriteNode(imageNamed: "joystickCircle")
    
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
        
            let handle = SKSpriteNode(imageNamed: "joystickStick")
            joystick.name = "joystickCircle"
            handle.name = "stick"
            
            addChild(joystick)
            if (neverJoyed) {
                joystick.addChild(handle)
                neverJoyed = false
            }
            joystick.size = CGSize(width: size.width/6, height: size.width/6)
            handle.size = CGSize(width: joystick.size.width/3, height: joystick.size.width/3)
            
            let INSIDE = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: ((joystick.size.width/2)-(handle.size.width/4))), to: joystick.position)
            
            
            handle.constraints = [INSIDE]
            joystick.position = tapPosition
            joystick.zPosition = 9
            handle.zPosition = 10
            handle.position = CGPoint(x:0,y:0)
        }
    }
    
    
    //when the touch ends, remove the joystick
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if the joy stick is active, remove it and remove any movement on Player
        if let joy = childNode(withName: "joystickCircle"){
            //joy.removeAllChildren()
            joy.childNode(withName: "stick")?.position = CGPoint(x: 0, y: 0)
            joy.removeFromParent()
            Player.physicsBody?.velocity = CGVector(dx:0,dy:0)
        } //the joystick is not there, error or different touch?
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        if let joy = childNode(withName: "joystickCircle"){ //IF a joystick EXISTS
            let innerPosition = touch.location(in: joy) //IF the TOUCH is in the JOYSTICK CIRCLE
            let handle = joy.childNode(withName: "stick")
            handle?.position = innerPosition //the stick will just follow the tap

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if let joy = childNode(withName: "joystickCircle"){ //IF a joystick EXISTS
            let handle = joy.childNode(withName: "stick")
            //every frame, we will set the character's velocity to move according to the stick's position
            
            //we need the angle of the stick and how far it is from the center
            
            //to do this we gotta make a triangle
            
            let thatX = Double(((handle?.position.x)!))
            let thatY = Double(((handle?.position.y)!))
            
            let ang = atan(thatY/thatX)
            var angInDegrees = ((ang*180)/Double.pi)
            
            if(thatX>0 && thatY>0){ //1st quadrant
                //nothing has to be changed
            } else if (thatX<0 && thatY > 0) { //2nd quadrant
                angInDegrees = 180 + angInDegrees
            } else if (thatX < 0 && thatY < 0) { //3rd
                angInDegrees += 180
            } else if (thatX > 0 && thatY < 0){ //4th
                angInDegrees = 360 + angInDegrees
            } else if (thatY == 0 && thatX > 0) { //right X axis
                angInDegrees = 0
            } else if (thatY == 0 && thatX < 0) { //left X axis
                angInDegrees = 180
            } else if (thatX == 0 && thatY < 0) { //lower Y axis
                angInDegrees = 270
            } else if (thatX == 0 && thatY > 0) { //upper Y axis
                angInDegrees = 90
            } else if (thatX == 0 && thatY == 0) { //straight middle
                angInDegrees = 0
            }
            
            let fixedAngInRadians = ((angInDegrees/180) * Double.pi)
            
            var percentX = abs(thatX / Double(joystick.size.width/2))
            var percentY = abs(thatY / Double(joystick.size.width/2))
            
            if (percentX > 1.0) {
                print(percentX)
                percentX = 1.0
            }
            if (percentY > 1.0) {
                percentY = 1.0
            }
            
            let y = sin(fixedAngInRadians) * haste * percentY
            let x = cos(fixedAngInRadians) * haste * percentX
            
            //let hypotenuse = sqrt(Double(Int(thatX)^2) + Double(Int(thatY)^2))
            
            //let radius = Double(joystick.size.width/2)
            
            Player.physicsBody?.velocity = CGVector(dx: x, dy: y)
        }
    }
}
