//
//  GameViewController.swift
//  simpleGame
//
//  Created by Jer Cherng Law on 4/1/15.
//  Copyright (c) 2015 evehandful. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    var backgroundMusicPlayer: AVAudioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
*/
    }
    
    // use for sizing purposes so that we can initialize our game scene 
        // where all the designing stuff will take place
    
    
    // create music player, need to import AVFoundation
    // and then create AVAudioPlayer
    
    override func viewWillLayoutSubviews() {
        var bgMusicURL: NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        // now call scene and show
        // sprite kit view SKView
        var skView: SKView = self.view as SKView // casting this for type safety
        
        // now show fps and node count label
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // now let's create the scene
        // -- this is the scene that we will create in GameScene.swift file
        var scene: SKScene = GameScene(size: skView.bounds.size)
        // ^ game scene is initialized with the bounds and size of skView
        
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(scene)
    }

    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
