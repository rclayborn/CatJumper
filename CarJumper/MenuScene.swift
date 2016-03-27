//
//  MenuScene.swift
//  CarJumper
//
//  Created by Randall Clayborn on 3/26/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var titleLabel = SKLabelNode()
    var scoreFlashAction = SKAction()
    
    override func didMoveToView(view: SKView) {
        
        titleLabel = SKLabelNode(fontNamed: "copperPlate")
        titleLabel.text = "Tap To Play?"
        titleLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        titleLabel.fontSize = 55
        titleLabel.alpha = 1.0
        titleLabel.zPosition = 12
        addChild(titleLabel)
        
        scoreFlashAction = SKAction.sequence([ SKAction.scaleTo(1.3, duration: 0.1), SKAction.scaleTo(1.0, duration: 0.5)])
        titleLabel.runAction( SKAction.repeatAction(scoreFlashAction, count: 20))

    }
    
 func GoGameScene() {

 let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
 let scene = GameScene(size: size)
 scene.scaleMode = SKSceneScaleMode.AspectFill
 view?.presentScene(scene, transition: transition)
            
        }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        GoGameScene()
    }

}
