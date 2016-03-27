//
//  GameScene.swift
//  CarJumper
//
//  Created by Randall Clayborn on 3/23/16.
//  Copyright (c) 2016 claybear39. All rights reserved.
//

import SpriteKit

let catCategory: UInt32 = 0x1 << 0
let carCategory: UInt32 = 0x1 << 1
let groundCategory: UInt32 = 0x1 << 2

class GameScene: SKScene, SKPhysicsContactDelegate {
        let enemy = SKSpriteNode(imageNamed: "pixelCar.png")
        let cat = SKSpriteNode(imageNamed: "cat.png")
        let ground = SKSpriteNode(imageNamed: "road.png")
        let background = SKSpriteNode(imageNamed: "CarJunkYard.png")
    
        var time: SKLabelNode!
        var timeInSeconds = 0
        var previousTimeInterval: CFTimeInterval = 0
        var randomNumber = Int(arc4random_uniform(UInt32(7)+3))
    
    override func didMoveToView(view: SKView) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Car Jumper"
        myLabel.fontSize = 105
        myLabel.fontColor = SKColor.orangeColor()
        myLabel.alpha = 1.0
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 200)
        self.addChild(myLabel)
        let fade = SKAction.fadeOutWithDuration(3)
        myLabel.runAction(fade)
        
         physicsWorld.contactDelegate = self
        createBackground()
        createCar()
        createCat()
        createGround()
        addLabels()
       
        let wait = SKAction.waitForDuration(Double(randomNumber))
        let run = SKAction.runBlock {
            self.carSpawn() //put method to go to in here.
            print("Random Number: \(self.randomNumber)")
        }
        self.runAction(SKAction.sequence([wait, run]))
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])))
        
    }
    
    func addLabels() {
        time = SKLabelNode(fontNamed: "copperPlate")
        time.fontColor = SKColor.orangeColor()
        time.alpha = 0.5
        time.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.85)
        time.fontSize = 50
        addChild(time)
        time.text = "Time: \(timeInSeconds)"
        
        let show = SKAction.fadeAlphaTo(1.0, duration: 3.5)
        time.runAction(show)
    }
    
    func createBackground() {
        background.position = CGPoint(x:0,y:0)
        background.anchorPoint = CGPoint(x:0.0,y:0.0)
        background.setScale(1.0)
        background.size.height = self.size.height
        background.size.width = self.size.width
        self.addChild(background)

    }
    
    func createCar() {
        //adding enemy
        enemy.position = CGPointMake(self.frame.width + 250, self.frame.height / 6 + 50)
        enemy.xScale = 2.5
        enemy.yScale = 2.5
        enemy.zPosition = 10// put it on top of label.
        self.addChild(enemy)
        
        let bodySize = CGSize(width: 295, height: 75)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize:bodySize)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.mass = 0.0
        enemy.physicsBody?.restitution = 0.0
        enemy.physicsBody?.categoryBitMask = carCategory
        enemy.physicsBody?.contactTestBitMask = catCategory
        enemy.physicsBody?.collisionBitMask = catCategory
    
    }
    
    func carSpawn() {
        
            let startPoint = CGPointMake(self.frame.width + 250, self.frame.height / 6 + 50)
            let endPoint = CGPointMake(-self.frame.width, self.frame.height / 6 + 50)
            
            let moveToEndAction = SKAction.moveTo(endPoint, duration: 2.5)
            let resetTostartAction = SKAction.moveTo(startPoint, duration: 0)
            
            let moveToEndThenStartAgain = SKAction.repeatActionForever(SKAction.sequence([moveToEndAction,resetTostartAction]))
            
             enemy.runAction(SKAction.repeatActionForever(moveToEndThenStartAgain))
    }
    
    func createCat() {
        //adding enemy
        cat.position = CGPointMake(self.frame.width * 0.2, self.frame.height / 6 + 50)
        cat.xScale = 0.1
        cat.yScale = 0.1
        cat.zPosition = 10// put it on top of label.
        
        //give physic body to bass.
        let bodySize = CGSize(width: 50, height: 70)
        cat.physicsBody = SKPhysicsBody(rectangleOfSize:bodySize)
        cat.physicsBody?.dynamic = true
        cat.physicsBody?.affectedByGravity = true
        cat.physicsBody?.mass = 0.0
        cat.physicsBody?.restitution = 0.8
        cat.physicsBody?.categoryBitMask = catCategory
        cat.physicsBody?.collisionBitMask = carCategory | groundCategory
        cat.physicsBody?.contactTestBitMask = carCategory | groundCategory
        self.addChild(cat)
        
    }
    
    func createGround() {
        ground.position = CGPointMake(self.frame.width * 0.5, self.frame.height / 6 - 100)
        ground.zPosition = 1// put it on top of label.
        
        //give physic body to bass.
        let bodySize = CGSize(width: 1050, height: 150)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize:bodySize)
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.mass = 0.0
        ground.physicsBody?.restitution = 0.0
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = catCategory
        ground.physicsBody?.contactTestBitMask = catCategory
        self.addChild(ground)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Cat jumping */
       cat.physicsBody?.applyImpulse(CGVector(dx: -0.05, dy: 350.0))
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == catCategory && contact.bodyB.categoryBitMask == carCategory || contact.bodyB.categoryBitMask == catCategory && contact.bodyA.categoryBitMask == carCategory {
            //jumping = false
            cat.removeFromParent()
            
            //end Game go to n=menu scene
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
            let scene = MenuScene(size: self.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            view?.presentScene(scene, transition: transition)
            
            //make sound
        } else if contact.bodyA.categoryBitMask == catCategory && contact.bodyB.categoryBitMask == groundCategory || contact.bodyB.categoryBitMask == catCategory && contact.bodyA.categoryBitMask == groundCategory {
            //do some here.
        }
    }


    override func update(currentTime: CFTimeInterval) {
        if previousTimeInterval == 0 {
            previousTimeInterval = currentTime
        }
        if paused {
            previousTimeInterval = currentTime; return
        }
        if currentTime - previousTimeInterval > 1 {
            timeInSeconds += Int(currentTime - previousTimeInterval)
            previousTimeInterval = currentTime
            
                time.text = "Time: \(timeInSeconds)"
            
        }
    }
    
}
