//
//  flappyUI.swift
//  flappy
//
//  Created by Marc on 25/06/2016.
//  Copyright © 2016 Marc. All rights reserved.
//

import SpriteKit


class startViewController : UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startView : SKView = self.view as! SKView
        startView.showsFPS = true
        startView.showsNodeCount = true
        
        
        // create the game scene by instanting the class which is an extends of the skscene
        
        let startScene = createUI(size: startView.bounds.size)
        
        startScene.scaleMode = .AspectFill
        startView.presentScene(startScene)
    }
}


@objc class createUI : SKScene{
    
    
    let startButton = SKSpriteNode(imageNamed: "start")
    let scoreButton = SKSpriteNode(imageNamed : "score")
    let soundButton = SKSpriteNode(imageNamed: "sound")
    let bg_color : SKColor = UIColor.init(colorLiteralRed: 120 / 255, green: 156 / 255, blue: 176 / 255, alpha: 1.0)
    
    
    override func didMoveToView(view: SKView) {
        // main func here
        self.backgroundColor = bg_color
        posButton()
        createButton()
    }
    
    
    func setName(){
        
        // set the name of the button in order to know which has been touch
        startButton.name = "start";
        scoreButton.name = "score";
        soundButton.name = "sound";
    }
    
    
    func posButton(){
        startButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 50)
        scoreButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        soundButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 50)
    }
    
    
    func createButton(){
        self.addChild(startButton)
        self.addChild(scoreButton)
        self.addChild(soundButton)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        
        if startButton.containsPoint(touch.locationInNode(self)){
            // instantiate the game scene
            let transition = SKTransition.fadeWithDuration(2.0)
            let gameScene = GameScene(size: self.view!.bounds.size)
            self.scene!.view?.presentScene(gameScene, transition : transition)
        }
        
    }
    

    
}