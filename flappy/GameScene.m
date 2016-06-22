//
//  GameScene.m
//  flappy
//
//  Created by Marc on 31/05/2016.
//  Copyright (c) 2016 Marc. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

static const uint32_t persoCategory = 1 << 0;
static const uint32_t mondeCategory = 1 << 1;
static const uint32_t obstacleCategory = 1 << 2;
static const uint32_t scoreCategory = 1 << 3;

-(id) initWithSize:(CGSize)size {
    
    
    
    // init scene
    if(self = [super initWithSize:size]){
        
        
        _noeudMouvment = [SKNode node];
        _ObstacleGroup = [SKNode node];
        _sauceNode = [SKNode node];
        self.physicsWorld.contactDelegate = self;
        int looper = 0;
        int looperCity = 0;
        int sizeT = 0;
        int sizeC = 0;
        
        _drapRestart = NO;
        _disableUserInput = NO;
        
        // config scene
        
        //_perso = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(50,50)];
        
        _scoreNumber = 0;
        // add the score...
        _scoreCounter = [SKLabelNode labelNodeWithFontNamed:@"slkscrb.ttf"];
        _scoreCounter.text = 0;
        _scoreCounter.position = CGPointMake(self.size.width / 2, self.size.height / 1.5);
        _scoreCounter.fontSize = 35;

        _fond = [SKColor colorWithRed: 120.0 / 255.0 green: 156.0 / 255.0 blue: 176.0 / 255.0 alpha:1.0];
       
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed: @"Sprites"];
        
        
        // ---------- TEXTURE ---------- //
        
        SKTexture *myTexture = [atlas textureNamed:@"ground"];
        SKTexture *city = [atlas textureNamed:@"bg_scenery"];
        SKTexture *user = [atlas textureNamed:@"one"];
        SKTexture *user_two = [atlas textureNamed:@"two"];
        _upperTube = [atlas textureNamed: @"chopstick_one"];
        _downTube = [atlas textureNamed: @"chopstick_two"];
        _soySauceBottle = [atlas textureNamed : @"soy_sauce_bottle"];
        _droplet = [atlas textureNamed:@"soy-sauce-droplet"];
        
    
        // call create obstacle
        
        
        SKAction *newObstacle = [SKAction performSelector: @selector(createObstacle) onTarget:self];
        
        
        
        
        SKAction *pause = [SKAction waitForDuration: 2.0];
    
        
        SKAction *animNewObs = [SKAction sequence: @[newObstacle, pause]];
        
        
        SKAction *animNouvelObstacleContinu = [SKAction repeatActionForever: animNewObs];
        
        
        // create new soy sauce
        
        SKAction *soySauceAction = [SKAction performSelector: @selector(createSoySauce) onTarget:self];
        
        
        SKAction *pauseSauce = [SKAction waitForDuration: 10.0];
        
        
        SKAction *animNewSoySauceObstalce = [SKAction sequence:@[soySauceAction, pauseSauce]];
        
        
        SKAction *animSauce = [SKAction repeatActionForever: animNewSoySauceObstalce];
        
        // anim of the city...
        
        SKAction *anim = [SKAction repeatActionForever: [SKAction animateWithTextures: @[user, user_two] timePerFrame:0.2]];
        
    
        SKAction *moveLandscape = [SKAction moveByX: -city.size.width * 0.6  y: 0 duration: 0.1 * city.size.width * 1];
    
        SKAction *resetLand = [SKAction moveByX:city.size.width * 0.6 y:0 duration:0];
        
        SKAction *animLandscape = [SKAction repeatActionForever: [SKAction sequence: @[moveLandscape, resetLand]]];
        
        
        // anim of the user
        
        
        SKAction *animGround = [SKAction repeatActionForever: [SKAction animateWithTextures: @[user, user_two] timePerFrame:0.2]];
        
        // anim of the ground
        
        SKAction *moveGround = [SKAction moveByX: -myTexture.size.width * 2 y: 0 duration: 0.1 * myTexture.size.width * 2];
        
        SKAction *resetGround = [SKAction moveByX:myTexture.size.width * 2 y:0 duration:0];
        
        SKAction *animSol = [SKAction repeatActionForever: [SKAction sequence: @[moveGround, resetGround]]];
        
        // add texture to user
        
        _perso = [SKSpriteNode spriteNodeWithTexture: user];
        _perso.position = CGPointMake(self.frame.size.width / 6, self.frame.size.height / 2);
        
        
        // add physics
        
        
        _perso.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: _perso.size.height / 2];
        // physics enable
        _perso.physicsBody.dynamic = YES;
        // the user is subject to gravity
        _perso.physicsBody.affectedByGravity = YES;
        // he's not affected by the rotation
        _perso.physicsBody.allowsRotation = NO;
        
        _perso.physicsBody.velocity = CGVectorMake(0, 0);
        
        _perso.physicsBody.categoryBitMask = persoCategory;
        _perso.physicsBody.collisionBitMask = mondeCategory | obstacleCategory;
        _perso.physicsBody.contactTestBitMask = mondeCategory | obstacleCategory;
        
        
        
        // apply the texture
        
        
        while(looper < (self.frame.size.width + sizeT)){
            _aSprite = [SKSpriteNode spriteNodeWithTexture: myTexture];
            _aSprite.position = CGPointMake(looper, 50);
            [_aSprite setScale: 1.0];
            [_noeudMouvment addChild: _aSprite];
            looper += _aSprite.size.width;
            [_aSprite runAction: animSol withKey: @"ground"];
            sizeT = _aSprite.size.width;
            
            
            _heightGround = (CGFloat) _aSprite.size.height;
            _widthGround =  (CGFloat) looper;

        }
        
        
        

        // create an empty sprite which simulated the physics of the ground
        CGSize sizeGround =CGSizeMake(_widthGround * 2, _heightGround * 2 - 15);
        SKNode *ground = [SKNode node];
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: sizeGround];
        ground.physicsBody.dynamic = NO;
        ground.position = CGPointMake(0,0);
        
        ground.physicsBody.categoryBitMask = mondeCategory;
        ground.physicsBody.contactTestBitMask = persoCategory;

        
    
        // add the city background
        
        
        while(looperCity < (self.frame.size.width + sizeC)){
            _citySprite = [SKSpriteNode spriteNodeWithTexture: city];
            _citySprite.position = CGPointMake(looperCity, (_heightGround * 2));
            [_citySprite setScale: 1];
            [_noeudMouvment addChild:_citySprite];
            _citySprite.zPosition = -15;
            sizeC = _citySprite.size.width * 2;
            looperCity += _citySprite.size.width;
            [_citySprite runAction: animLandscape withKey: @"restaurant"];
        }

        
        
       // SKSpriteNode *aSprite = [SKSpriteNode spriteNodeWithTexture: myTexture];

        [self addChild: _noeudMouvment];
        [_noeudMouvment addChild : ground];
        [_noeudMouvment addChild : _perso];
        [_noeudMouvment addChild: _scoreCounter];
        [_perso runAction: anim];
        [_perso setScale: 0.1];
        [_noeudMouvment addChild: _ObstacleGroup];
        [_noeudMouvment addChild: _sauceNode];
        [self runAction: animNouvelObstacleContinu];
        [self runAction: animSauce];
        [self setBackgroundColor: _fond];
        
        
        // update the gravity
    
        self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
        
    

    }
    
    
    return self;
}


-(void) createObstacle{
    const double space_const = 100;
    // get the atlas
    
    int posy = 0;
    CGFloat textureSizeX = 0;
    CGFloat textureSizeY = 0;
    

    textureSizeX = _upperTube.size.width;
    textureSizeY = _upperTube.size.height;
    
    
    // create node
    
    
    _bar = [SKNode node];
    _bar.position = CGPointMake(self.frame.size.width + (_upperTube.size.width), 0);
    _bar.zPosition = -10;
    
    // posy
    
    posy = arc4random_uniform((self.frame.size.height) / 3);
    
    // define sprite
    
    SKSpriteNode *downSprite = [SKSpriteNode spriteNodeWithTexture: _upperTube];
    downSprite.position = CGPointMake(0, posy);
    
    SKSpriteNode *upSprite = [SKSpriteNode spriteNodeWithTexture: _downTube];
    upSprite.position = CGPointMake(0, (posy+downSprite.size.height+ space_const));
    
    // add physics
    
    downSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(textureSizeX, textureSizeY)];
    upSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(textureSizeX, textureSizeY)];
    
    
    downSprite.physicsBody.dynamic = NO;
    upSprite.physicsBody.dynamic = NO;
    
    
    
    downSprite.physicsBody.contactTestBitMask = persoCategory;
    downSprite.physicsBody.categoryBitMask = obstacleCategory;

    upSprite.physicsBody.contactTestBitMask = persoCategory;
    upSprite.physicsBody.categoryBitMask = obstacleCategory;
    
    
    // node to get the score using a new collider
    
    
    CGSize sizeCollider = CGSizeMake((downSprite.size.width - 3), (downSprite.size.height - space_const ));
  
    //SKNode *scoreNode = [SKNode node];
    SKNode *scoreNode = [SKSpriteNode spriteNodeWithColor: [SKColor colorWithRed: 0 green:0 blue:0 alpha:0]  size: CGSizeMake((downSprite.size.width - 3), downSprite.size.height - space_const)];
    
    scoreNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: sizeCollider];

    scoreNode.physicsBody.dynamic = NO;
    scoreNode.position = CGPointMake(downSprite.size.width, (downSprite.position.y + (space_const + 50)));
    
    scoreNode.physicsBody.contactTestBitMask = persoCategory;
    scoreNode.physicsBody.categoryBitMask = scoreCategory;
    


    int distance = (self.frame.size.width + (textureSizeX * 2));
    
    SKAction *bougerObstacle = [SKAction moveByX: -distance y : 0 duration: 0.01 * distance];
    SKAction *supprimerObstacle = [SKAction removeFromParent];
    
     SKAction *animObs = [SKAction repeatActionForever: [SKAction sequence: @[bougerObstacle, supprimerObstacle]]];
    
    [_bar runAction: animObs];
    
    [_bar addChild : downSprite];
    [_bar addChild : upSprite];
    [_bar addChild: scoreNode];
    [_ObstacleGroup addChild: _bar];
}


-(void) createSoySauce{
    
    SKNode *scNode = [SKNode node];
    
    SKSpriteNode *soySauceNode = [SKSpriteNode spriteNodeWithTexture: _soySauceBottle];
    
    soySauceNode.position = CGPointMake(self.frame.size.width + 50, (self.frame.size.height - 10));
    soySauceNode.zPosition = -10;
    [soySauceNode setScale: 0.2];
    
    int dis = (self.frame.size.width + _soySauceBottle.size.width * 2);
    
    SKAction *moveSauceBottle = [SKAction moveByX : -dis y: 0 duration: 0.01 * dis];
    
    SKAction *deleteSauceBottle = [SKAction removeFromParent];
    
    SKAction *animSoy = [SKAction repeatActionForever: [SKAction sequence: @[moveSauceBottle, deleteSauceBottle]]];
    

    [scNode addChild: soySauceNode];
    [scNode runAction: animSoy];
    [_sauceNode addChild: scNode];
    
}

-(void) createDropplet{
    SKNode *parentDroplet = [SKNode node];
    SKSpriteNode *droplet = [SKSpriteNode spriteNodeWithTexture: _droplet];
    
    droplet.position = CGPointMake(self.frame.size.width + 50, self.frame.size.height);
    droplet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: 2];
    
    int distanceDroplet = (self.frame.size.height + droplet.size.height * 2);

    
    droplet.zPosition = -11;
    [droplet setScale : 0.1];
    
    
    [parentDroplet addChild: droplet];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // if the user touch an obstacle -> disable the user interaction with the player
    
    if(!_disableUserInput){
        [_perso.physicsBody applyImpulse: CGVectorMake(1,400)];
    }
    
    
    
}


- (void)didBeginContact:(SKPhysicsContact *) contact {
   // NSLog(@"lalalalalalalalal %*", contact);
    

    if(((contact.bodyA.categoryBitMask & obstacleCategory) == obstacleCategory)){
 
        if(_noeudMouvment.speed > 0){
            
              _noeudMouvment.speed = 0;
              _disableUserInput = YES;
        }
    }
    else if(((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory)){
        ++_scoreNumber;
        NSLog(@"number %i", _scoreNumber);
        _scoreCounter.text = [NSString stringWithFormat:@"%i", _scoreNumber];
    }
    else if(_drapRestart){
       // NSLog(@"ici");
       // [self reinitScene];
    }
    else{
        
        [self removeActionForKey:@"collision"];
        SKAction *flashYellow = [SKAction runBlock:^{self.backgroundColor = [SKColor yellowColor];}];
        
        SKAction *pause1 = [SKAction waitForDuration:0.05];
        SKAction *flashCiel =  [SKAction runBlock:^{self.backgroundColor = _fond;}];
        
        SKAction *pause2 = [SKAction waitForDuration: 0.05];
        SKAction *bgBlinkY = [SKAction sequence:@[flashYellow, pause1, flashCiel, pause2]];
        
        SKAction *alertY = [SKAction repeatAction: bgBlinkY count: 4];
        [self runAction: alertY withKey:@"collision"];
    }
}

-(void) reinitScene{
    NSLog(@"ici");
    

    _perso.position = CGPointMake(0,0);
    _perso.physicsBody.velocity = CGVectorMake(0, 0);
    NSLog(@"%f", _perso.position.y);
    [_ObstacleGroup removeAllChildren];
    //_noeudMouvment.speed = 0;
    //_drapRestart = NO;
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end