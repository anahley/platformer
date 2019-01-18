//
//  SceneOne.swift
//  platformer
//
//  Created by 90305539 on 11/27/18.
//  Copyright © 2018 Emir Sahbegovic. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let ground: UInt32 = 0b1 //1
    static let player: UInt32 = 0b10 //2
    static let camBounds: UInt32 = 0b100 //4
    static let object: UInt32 = 0b1000 //8
    
}

/**
 Scene for level one
 */
class SceneOne: SKScene {

    
    var airborne = true
    var neverJoyed = true
    var inControl = true
    var camPos = -1
    var camCooldown = true
    var jumpPower = 1500000.0
    var maxSpeed = 666.666
    var Player = SKSpriteNode(imageNamed: "guywalking1")
    let joystick = SKSpriteNode(imageNamed: "joystickCircle")
    var TextureAtlas = SKTextureAtlas(named: "assets")
    var TextureArray = [SKTexture]()

    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        Player = childNode(withName: "guy") as! SKSpriteNode
        Player.physicsBody?.categoryBitMask = PhysicsCategory.player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
        
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
        
            let handle = SKSpriteNode(imageNamed: "JoystickStick")
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
        if airborne == false { //if you're not jumping
            
            if Player.physicsBody!.velocity.dx == 0  { 
                animation()
            }
            
            if Player.physicsBody!.velocity.dx < 0 {
                if Player.xScale > 0 {
                   Player.xScale = Player.xScale * -1
                }
            }
            
            if Player.physicsBody!.velocity.dx > 0 {
                if Player.xScale < 0 {
                    Player.xScale = Player.xScale * -1
                }
                
            }
            
        }
        
        if airborne == true {
            Player.run(SKAction.setTexture(SKTexture(imageNamed: "guyjump")))
        }
    }
    
    
    /**
     When this function is called, the character will either move left, right, crouch, or jump.
     */
    func movement(angInRads: Double, percentX: Double, percentY: Double) {
        
        //the speed which the player is looking for based on the character's max speed and where the joystick is
        let speedXToReach = CGFloat(cos(angInRads) * maxSpeed * percentX)
        let currentSpeedX = Player.physicsBody?.velocity.dx
        //how close the joystick is to the edge, 1.0 = max 0.0 = center
        let hypoUnitCircle = sqrt((percentX * percentX) + (percentY * percentY))
        
        //if they are IN CONTROL
        if (inControl) {
            if (angInRads > Double.pi/4 && angInRads < 3 * Double.pi/4 && hypoUnitCircle > 0.85 && !airborne) { //JUMP
                let force = CGVector(dx: Double(speedXToReach), dy: jumpPower)
                Player.physicsBody?.applyForce(force)
                airborne = true
            }
            if (angInRads > 5 * Double.pi/4 && angInRads < 7 * Double.pi/4 && percentY > 0.85) { //CROUCH
                //what?
            } else if (angInRads <  (Double.pi/4) || angInRads > (7 * Double.pi/4)) { //MOVE RIGHT
                Player.physicsBody?.velocity.dx += ((speedXToReach - currentSpeedX!) / 4)
                Player.physicsBody?.velocity.dy = 1
            } else { //MOVE LEFT
                Player.physicsBody?.velocity.dx += ((speedXToReach - currentSpeedX!) / 4)
                Player.physicsBody?.velocity.dy = 1
            }
        }
        
    }

    func animation() {
        for i in 1...TextureAtlas.textureNames.count{
            
            var Name = "guywalking\(i).png"
            TextureArray.append(SKTexture(imageNamed: Name))
            Player.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.3)))
        }
    }
    
}

extension SceneOne: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if (firstBody.categoryBitMask == PhysicsCategory.ground && secondBody.categoryBitMask == PhysicsCategory.player) {
            let groundPos = firstBody.node?.position.y
            let playerpos = secondBody.node?.position.y
            if (Double(groundPos!) < Double(playerpos!)){
                airborne = false
            }
        }
        if(secondBody.categoryBitMask == PhysicsCategory.camBounds) {
            if(camCooldown) { //if the camera is ready
                camCooldown = false
                if(secondBody.node!.name == "camHitboxRight") { // camera moves to next node to the right
                    let nodeToTheRight = ("node" + String(camPos + 1)) //the node to the right
                    let node = (childNode(withName: nodeToTheRight)?.position.x)
                    if (node != nil) { //if there is a node to the right, change cameras
                        camPos += 1
                        let moveToThis = ("node" + String(camPos))
                        camera?.position.x = (childNode(withName: moveToThis)?.position.x)!//368
                        
                        let point = CGPoint(x: ((camera?.position.x)! + 370), y: 0.0)
                        let leftPoint = CGPoint(x: ((camera?.position.x)! - 370), y: 0.0)
                        childNode(withName: "camHitboxLeft")?.run((SKAction.move(to: leftPoint, duration: 0.5)))
                        secondBody.node?.run((SKAction.move(to: point, duration: 0.5)))
                    }
                } else { //camera moves to the node to the left
                    let nodeToTheRight = ("node" + String(camPos - 1)) //the node to the right
                    let node = (childNode(withName: nodeToTheRight)?.position.x)
                    if (node != nil) { //if there is a node to the right, change cameras
                        camPos -= 1
                        let moveToThis = ("node" + String(camPos))
                        camera?.position.x = (childNode(withName: moveToThis)?.position.x)!
                        
                        let point = CGPoint(x: ((camera?.position.x)! - 370), y: 0.0)
                        let rightPoint = CGPoint(x: ((camera?.position.x)! + 370), y: 0.0)
                        childNode(withName: "camHitboxRight")?.run((SKAction.move(to: rightPoint, duration: 0.5)))
                        secondBody.node?.run((SKAction.move(to: point, duration: 0.5)))
                    }
                }
                run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run { //puts the camera on cooldown as to not spam camera change
                    self.camCooldown = true
                }]))
            }
        }
    }
}
