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
    
    // give it a bitmask using this strange looking code
    let alienCategory: UInt32 = 0x1 << 1 // creates a bitwise multiplication, we're multiplying 0x1 by 1
                                         // it will identify our alien when we're doing a collision with the photon Torpedo
    let photonTorpedoCategory: UInt32 = 0x1 << 0 // all we need to know to determine the differences between the categories
    
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
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        // ^--- crude, does this mean every alien is basically a rectangle?
        alien.physicsBody?.dynamic = true
        
        // now give alien category bitmask and contact bitmask 
        // necessary to detect collision with photon torpedo
        alien.physicsBody?.categoryBitMask = alienCategory
        
        // this something contact with torpedo
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        // when do we use '!' or '?' ? is it like ruby?
        
        // we will now set/give our alien a position which should be set on random on the x-axis (no y-axis)
        // use very simple approach by creating a constant
        let minX = alien.size.width/2
        // use the maximum size of the frame - half width of alien so that the alien is not spawned outside the phone screen
        let maxX = self.frame.size.width - alien.size.width/2
        
        // to create a range of values where our alien can appear on the x-axis
        let range = maxX - minX
        
        // now let's create the randomizer function
        // going to use in a floating point
        let position: CGFloat = (CGFloat(arc4random())) % CGFloat(range) + CGFloat(minX)
        
        alien.position = CGPointMake(position, self.frame.size.height+alien.size.height)
        self.addChild(alien)
        
        // create movement in our game
        // define speed and duration of animation
        // want the aliens to have different speed
        // use same approach for random x with random speed
        let minDuration = 2
        let maxDuration = 4
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        
        var actionArray: NSMutableArray = NSMutableArray()
        
        actionArray.addObject(SKAction.moveTo(CGPointMake(position, -alien.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.runBlock({
            var transition: SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
            var gameOverScene: SKScene = GameOverScene(size: self.size, won: false)
            // set false because alien ship within addAlien method parameter -alien.size.height guarantees that the alien has gone past space ship therefore player loses.
            self.view?.presentScene(gameOverScene, transition: transition)
        }))
        actionArray.addObject(SKAction.removeFromParent())
        
        alien.runAction(SKAction.sequence(actionArray))
        
        
    }
    
    // why is this important?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        
        // add time since last update to yield time property
        lastYieldTimeInterval += timeSinceLastUpdate
        
        if(lastYieldTimeInterval > 1) {
            lastYieldTimeInterval = 0
            addAlien()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimerInterval
        lastUpdateTimerInterval = currentTime
        
        // check meaning more than a second has passed
        if(timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1/60
            lastUpdateTimerInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    
    
    // created standard spaceship coming from XCode
/*
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
*/
    // writing mathematical functions to do vector calculations for trajectory of lasers
    func vecAdd(a: CGPoint, b: CGPoint) -> CGPoint{
        return CGPointMake(a.x + b.x, a.y + b.y)
    } // -- what are CGPoints?
    
    func vecSub(a: CGPoint, b: CGPoint) -> CGPoint{
        return CGPointMake(a.x - b.x, a.y - b.y)
    }
    
    func vecMultiply(a: CGPoint, b: CGFloat) -> CGPoint{
        return CGPointMake(a.x * b, a.y * b)
    }
    
    func vecLength(a:CGPoint) -> CGFloat {
        return CGFloat(sqrtf(CFloat(a.x) * CFloat(a.x) + (CFloat(a.y) * CFloat(a.y))))
        // what is the difference between CGFloat and CFloat?
    }

    func vecNormalize(a: CGPoint) -> CGPoint {
        var length: CGFloat = vecLength(a)
        return CGPointMake(a.x/length, a.y/length)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        var touch: UITouch = touches.anyObject() as UITouch
        
        var location:CGPoint = touch.locationInNode(self)
        
        // create sprite node for torpedo
        var torpedo: SKSpriteNode = SKSpriteNode(imageNamed: "torpedo")
        torpedo.position = player.position
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width/2)
        torpedo.physicsBody?.dynamic = true
        torpedo.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedo.physicsBody?.contactTestBitMask = alienCategory
        torpedo.physicsBody?.collisionBitMask = 0
        
        // what does this do?
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        
        // math calculation start with offset, begin with spaceship between alien, point where we touched on the screen
        
        var offset:CGPoint = vecSub(location, b: torpedo.position)
        
        // won't add torpedo if touch somewhere below spaceship
        if(offset.y < 0) {
            return
        }
        
        self.addChild(torpedo)
        
        var direction: CGPoint = vecNormalize(offset)
        
        // now define length of vec to determine how far torpedo goes once fired
        // 1000 is a fixed length we know will be off our screen, maybe I can use screen size for this parameter?
        var shotLength: CGPoint = vecMultiply(direction, b: 1000)
        
        var finalDestination: CGPoint = vecAdd(shotLength, b: torpedo.position)
        
        // velocity
        let velocity = 568/1
        let moveDuration: Float = Float(self.size.width) / (Float(velocity))
        
        
        var actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject((SKAction.moveTo(finalDestination, duration: NSTimeInterval(moveDuration))))
        
        actionArray.addObject(SKAction.removeFromParent())
        
        torpedo.runAction(SKAction.sequence(actionArray))
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0) {
            torpedoDidCollideWithAlien(firstBody.node as SKSpriteNode, alien: secondBody.node as SKSpriteNode)
            // now our collision test should be working
            
        }
    }
    
    func torpedoDidCollideWithAlien(torpedo: SKSpriteNode, alien: SKSpriteNode) {
        println("HIT")
        torpedo.removeFromParent()
        alien.removeFromParent()
        
        aliensDestroyed++
        
        if(aliensDestroyed > 10) {
            // transition to GameOver or Success
            // use contact delegate
            var transition: SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
            var gameOverScene: SKScene = GameOverScene(size: self.size, won: true)
            // set false because alien ship within addAlien method parameter -alien.size.height guarantees that the alien has gone past space ship therefore player loses.
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
}