//
//  GameScene.swift
//  simpleGame
//
//  Created by Jer Cherng Law on 4/1/15.
//  Copyright (c) 2015 evehandful. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // this variable is our player
    var player:SKSpriteNode = SKSpriteNode()
    
    // below two properties decide when to create aliens
    var lastYieldTimeInterval: NSTimeInterval = NSTimeInterval()
    var lastUpdateTimerInterval: NSTimeInterval = NSTimeInterval()
    
    // counts the number of aliens destroyed
    var aliensDestroyed: Int = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Helvetica Neue")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        */
    }
    
    override init(size: CGSize){
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        // should figure out how to add background image instead.
        // -- how do platform games move through the image? I think that's quite 
        // interetesting
        
        //begin creating player object
        player = SKSpriteNode(imageNamed: "shuttle")
        // self.frame.size.width/2 places the image in the middle of the screen
        player.position = CGPointMake(self.frame.size.width/2, player.size.height/2 + 20)
            // note that the coordinate system isn't starting at the upper left corner but lower left corner
        
        self.addChild(player)
        
        // give it gravity of 0 0 so no direction, character stands still
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        // used later to detect whether alien hit torpedo shot collide or not
        self.physicsWorld.contactDelegate = self
    }
    
    // now to create aliens!
    func addAlien() {
        var alien: SKSpriteNode = SKSpriteNode(imageNamed: "alien")
        
        // give physics body to detect collisions more accurately and simulating collision effects
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size) // crude, does this mean every alien is basically a rectangle? 
        alien.physicsBody?.dynamic = true
        
        // now give alien category bitmask and contact bitmask 
        // necessary to detect collision with photon torpedo
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
