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

    
    var jumping = false
    var neverJoyed = true
    var jumpPower = 500000.0
    var haste = 500000.0
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
        
        let tapPosition = touch.location(in: camera!)
        
        //IF the touch is in the bottom left quarter, JOYSTICK IS ENABLED
        if ((tapPosition.x < 0) && (tapPosition.y < 0)) {
        
            let handle = SKSpriteNode(imageNamed: "joystickStick")
            joystick.name = "joystickCircle"
            handle.name = "stick"
            
            camera?.addChild(joystick)
            
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
        if let joy = camera?.childNode(withName: "joystickCircle"){
            //joy.removeAllChildren()
            joy.childNode(withName: "stick")?.position = CGPoint(x: 0, y: 0)
            joy.removeFromParent()
            jumping = false
            //Player.physicsBody?.velocity = CGVector(dx:0,dy:0)
        } //the joystick is not there, error or different touch?
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        if let joy = camera?.childNode(withName: "joystickCircle"){ //IF a joystick EXISTS
            let innerPosition = touch.location(in: joy) //IF the TOUCH is in the JOYSTICK CIRCLE
            let handle = joy.childNode(withName: "stick")
            handle?.position = innerPosition //the stick will just follow the tap

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if let joy = camera?.childNode(withName: "joystickCircle"){ //IF a joystick EXISTS
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
                percentX = 1.0
            }
            if (percentY > 1.0) {
                percentY = 1.0
            }
            
            movement(angInRads: fixedAngInRadians, percentX: percentX, percentY: percentY)
            
            //Primitive movement------------------------------------------
        }
        
        
        camera?.position.x = Player.position.x
    }
    
    
    /**
     When this function is called, the character will either move left, right, crouch, or jump.
     */
    func movement(angInRads: Double, percentX: Double, percentY: Double) {
        var force = CGVector(dx: 0, dy: 0)
        var y = sin(angInRads) * jumpPower
        var x = cos(angInRads) * haste * percentX
        
        let hypoUnitCircle = sqrt((percentX * percentX) + (percentY * percentY))
        
        if (!jumping) {
        
            if (angInRads > Double.pi/4.0 && angInRads < 3 * Double.pi/4.0 && hypoUnitCircle > 0.85) { //JUMP

                jumping = true
                
                force = CGVector(dx: x, dy: y)
            } else if (angInRads > 5 * Double.pi/4.0 && angInRads < 7 * Double.pi/4.0 && percentY > 0.85) { //CROUCH
                let y = sin(angInRads) * -jumpPower
                let x = cos(angInRads) * haste * percentX
                force = CGVector(dx: x, dy: y)
            }
            
        }
        
        Player.physicsBody?.applyForce(force)
    }
}
