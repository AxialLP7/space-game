//
//  GameOverScene.swift
//  simpleGame
//
//  Created by Jer Cherng Law on 4/3/15.
//  Copyright (c) 2015 evehandful. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.orangeColor()
        
        var message: NSString = NSString()
        
        if(won) {
            message = "you win"
        }
        
        else {
            message = "game over"
        }
        
        var label: SKLabelNode = SKLabelNode(fontNamed: "Zapfino")
        label.text = message
        label.fontColor = SKColor.whiteColor()
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(label)
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(3.0), SKAction.runBlock({
            var transition: SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
            var scene: SKScene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        })]))
    }

    // still don't understand what this is for
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
