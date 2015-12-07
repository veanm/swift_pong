//
//  GameScene.swift
//  Pong
//
//  Created by 20059076 on 27/11/2015.
//  Copyright (c) 2015 WIT. All rights reserved.
//

import SpriteKit;

class GameScene: SKScene {
    
    //==== General Game ====//
    var lastTime: CFTimeInterval = 0;
    var waitTime: CFTimeInterval = 2;
    
    let BORDER_SIZE			= 10	as Float;
    let MARGIN_SIZE			= 20	as Float;
    let	SCREEN_WIDTH		= 568	as Float;
    let SCREEN_HEIGHT		= 320	as Float;
    
    var debugLabel	: SKLabelNode = SKLabelNode();
    var debugBall	: SKSpriteNode = SKSpriteNode();
    
    var pGamestate = 0 as Int;
    var Gamestate = 0 as Int	// 0 = main menu, 1 = gameplay, 2 = game paused;
    
    var Gamemode = 0 as Int;	/*	-| 0 = Two Ai Players
                                 *	-| 1 = One Ai Player, One Human Player
    							 *	-| 2 = Two Human Players
    							 */
    
    //=== Menus ===//
    var play_0 : SKSpriteNode = SKSpriteNode();
    var play_1 : SKSpriteNode = SKSpriteNode();
    var play_2 : SKSpriteNode = SKSpriteNode();
    var label_0 : SKLabelNode = SKLabelNode();
    var label_1 : SKLabelNode = SKLabelNode();
    var label_2 : SKLabelNode = SKLabelNode();
    
    var pause_button : SKSpriteNode = SKSpriteNode();
    var pause_label : SKLabelNode = SKLabelNode();
    var quit_button : SKSpriteNode = SKSpriteNode();
    var quit_label : SKLabelNode = SKLabelNode();
    
    //==== Ball Shit ====//
    let BALL_SIZE			= 10	as Float;
    let BALL_SPEED_MIN		= 400	as Float;
    let BALL_SPEED_MAX		= 400	as Float;
    
    struct Ball {
        var ballNode	: SKSpriteNode;
        var x, y		: Float;
        var dx, dy		: Float;
        var angle		: Float;
        var speed		: Float;
        
        init(){
            ballNode = SKSpriteNode();
            self.x 	= 0; self.y 	= 0;
            dx 		= 0; dy			= 0;
            angle = 0;
            speed = 0;
        }
    };
    var ball : Ball = Ball();
    
    
    //==== Paddle Shit ====//
    let PADDLE_WIDTH		= 10	as Float;
    let PADDLE_HEIGHT_MIN	= 30	as Float;
    let PADDLE_HEIGHT_MAX	= 70	as Float;
    let PADDLE_SPEED		= 300	as Float;
    
    struct Paddel {
        var PaddleNode	: SKSpriteNode;
        var x, y		: Float;
        var dx, dy		: Float;
        var height		: Float;
        var speed		: Float;
        var disToHitAngle : Float;
        var isHuman		: Bool;
        var score		: Int;
        var scoreObject : SKLabelNode;
        var lives		: Int;
        var livesObject : SKLabelNode;
        
        init(){
            PaddleNode = SKSpriteNode();
            x = 0; y = 0;
            dx = 0; dy = 0;
            height = 0;
            speed = 0;
            disToHitAngle = 0;
            isHuman = false;
            score = 0;
            scoreObject = SKLabelNode();
            lives = 3;
            livesObject = SKLabelNode();
        }
    };
    var paddleL	: Paddel = Paddel();
    var paddleR	: Paddel = Paddel();
    
    var INPUT_AREA_LEFT  = SKSpriteNode();
    var INPUT_AREA_RIGHT = SKSpriteNode();
    
    
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
    
    func initt(){
        ball.ballNode.size.width	= CGFloat(BALL_SIZE);
        ball.ballNode.size.height	= CGFloat(BALL_SIZE);
        ball.x			= SCREEN_WIDTH/2;
        ball.y			= SCREEN_HEIGHT/2;
        ball.angle		= 45;
        ball.speed		= BALL_SPEED_MIN;
        
        paddleL.x			= 0 + BORDER_SIZE/2;
        paddleL.y			= (SCREEN_HEIGHT - MARGIN_SIZE)/2;
        paddleL.dx			= paddleL.x;
        paddleL.dy			= paddleL.y;
        paddleL.height		= PADDLE_HEIGHT_MAX;
        paddleL.speed		= PADDLE_SPEED;
        var randomAngle = Float(arc4random() % 90 + 1);
        paddleL.disToHitAngle = calcDisForAngle(randomAngle - 45, paddle_height: paddleL.height);
        paddleL.score = 0;
        paddleL.lives = 3;

        paddleR.x			= SCREEN_WIDTH - BORDER_SIZE/2;
        paddleR.y			= (SCREEN_HEIGHT - MARGIN_SIZE)/2;
        paddleR.dx			= paddleR.x;
        paddleR.dy			= paddleR.y;
        paddleR.height		= PADDLE_HEIGHT_MAX;
        paddleR.speed		= PADDLE_SPEED;
        randomAngle = Float(arc4random() % 90 + 1);
        paddleR.disToHitAngle = calcDisForAngle(randomAngle - 45, paddle_height: paddleR.height);
        paddleR.score = 0;
        paddleR.lives = 3;
        
        if(Gamemode == 0){
            paddleL.isHuman = false;
            paddleR.isHuman = false;
            INPUT_AREA_LEFT.hidden = true;
            INPUT_AREA_RIGHT.hidden = true;
        }else
        if(Gamemode == 1){
        	paddleL.isHuman = true;
            paddleR.isHuman = false;
            INPUT_AREA_LEFT.size.width	= CGFloat(SCREEN_WIDTH);
            INPUT_AREA_LEFT.size.height	= CGFloat(SCREEN_HEIGHT - BORDER_SIZE*2 - MARGIN_SIZE);
            INPUT_AREA_LEFT.position.x	= CGFloat(SCREEN_WIDTH/2);
            INPUT_AREA_LEFT.position.y	= CGFloat(SCREEN_HEIGHT+MARGIN_SIZE)/2;
            INPUT_AREA_RIGHT.hidden		= true;
        }else
        if(Gamemode == 2){
            paddleL.isHuman = true;
            paddleR.isHuman	= true;
            INPUT_AREA_LEFT.size.width	= CGFloat(SCREEN_WIDTH/2);
            INPUT_AREA_LEFT.size.height	= CGFloat(SCREEN_HEIGHT - BORDER_SIZE*2 - MARGIN_SIZE);
            INPUT_AREA_LEFT.position.x	= CGFloat(SCREEN_WIDTH/4);
            INPUT_AREA_LEFT.position.y	= CGFloat(SCREEN_HEIGHT+MARGIN_SIZE)/2;
            INPUT_AREA_RIGHT.size.width	= CGFloat(SCREEN_WIDTH/2);
            INPUT_AREA_RIGHT.size.height = CGFloat(SCREEN_HEIGHT - BORDER_SIZE*2 - MARGIN_SIZE);
            INPUT_AREA_RIGHT.position.x	= CGFloat(SCREEN_WIDTH/4)*3;
            INPUT_AREA_RIGHT.position.y	= CGFloat(SCREEN_HEIGHT+MARGIN_SIZE)/2;
                    
        }
        
    }
    
    
//--------------------------------------------------------------------------------------------------
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        Gamestate = 0;
        pGamestate = 2;
        
        play_0 = childNodeWithName("o_Play_0") as! SKSpriteNode;
        play_1 = childNodeWithName("o_Play_1") as! SKSpriteNode;
        play_2 = childNodeWithName("o_Play_2") as! SKSpriteNode;
        label_0 = childNodeWithName("o_Label_0") as! SKLabelNode;
        label_1 = childNodeWithName("o_Label_1") as! SKLabelNode;
        label_2 = childNodeWithName("o_Label_2") as! SKLabelNode;
        
        play_0.hidden = false;
        play_1.hidden = false;
    	play_2.hidden = false;
        label_0.hidden = false;
        label_1.hidden = false;
        label_2.hidden = false;
        
        play_0.position.x = CGFloat(SCREEN_WIDTH/2 - 150);
        play_1.position.x = CGFloat(SCREEN_WIDTH/2 - 150);
        play_2.position.x = CGFloat(SCREEN_WIDTH/2 - 150);
        label_0.position.x = CGFloat(SCREEN_WIDTH/2);
        label_1.position.x = CGFloat(SCREEN_WIDTH/2);
        label_2.position.x = CGFloat(SCREEN_WIDTH/2);
        
        play_0.position.y = CGFloat(SCREEN_HEIGHT/2 + 100 - 10);
        play_1.position.y = CGFloat(SCREEN_HEIGHT/2 - 10);
        play_2.position.y = CGFloat(SCREEN_HEIGHT/2 - 100 - 10);
        label_0.position.y = CGFloat(SCREEN_HEIGHT/2 + 100);
        label_1.position.y = CGFloat(SCREEN_HEIGHT/2);
        label_2.position.y = CGFloat(SCREEN_HEIGHT/2 - 100);
        
        pause_button = childNodeWithName("o_Pause_button") as! SKSpriteNode;
        pause_label = childNodeWithName("o_Pause_label") as! SKLabelNode;
        quit_button = childNodeWithName("o_Pause_quit") as! SKSpriteNode;
        quit_label = childNodeWithName("o_Pause_quitLabel") as! SKLabelNode;
        
        pause_button.hidden = true;
        pause_label.hidden = true;
        quit_button.hidden = true;
        quit_label.hidden = true;
        
        pause_button.position.x = CGFloat(SCREEN_WIDTH/2 - 50);
        pause_button.position.y = CGFloat(0);
        pause_label.position.x = CGFloat(SCREEN_WIDTH/2);
        pause_label.position.y = CGFloat(10);
        
        quit_button.position.x = CGFloat(SCREEN_WIDTH/2 - 150);
        quit_button.position.y = CGFloat(SCREEN_HEIGHT/2 - 15);
        quit_label.position.x = CGFloat(SCREEN_WIDTH/2);
        quit_label.position.y = CGFloat(SCREEN_HEIGHT/2);
        
        debugLabel = childNodeWithName("debug_Label") as! SKLabelNode;
        debugBall  = childNodeWithName("o_DebugBall") as! SKSpriteNode;
        debugBall.hidden = true;
        
        debugLabel.fontSize = 10;
        debugLabel.position.x = 2;
        debugLabel.position.y = CGFloat(SCREEN_HEIGHT - BORDER_SIZE - 2);
        
        
        ball.ballNode	= childNodeWithName("o_Ball") as! SKSpriteNode;
        ball.ballNode.size.width	= CGFloat(BALL_SIZE);
        ball.ballNode.size.height	= CGFloat(BALL_SIZE);
        ball.x			= SCREEN_WIDTH/2;
        ball.y			= SCREEN_HEIGHT/2;
        ball.angle		= 45;
        ball.speed		= BALL_SPEED_MIN;

        
        paddleL.PaddleNode	= childNodeWithName("o_Paddle_L") as! SKSpriteNode;
    	paddleL.PaddleNode.size.width	= CGFloat(PADDLE_WIDTH);
        paddleL.PaddleNode.size.height	= CGFloat(PADDLE_HEIGHT_MAX);
        paddleL.scoreObject = childNodeWithName("o_Screen_left_score") as! SKLabelNode;
        paddleL.livesObject = childNodeWithName("o_Screen_left_lives") as! SKLabelNode;
        
        
        paddleR.PaddleNode	= childNodeWithName("o_Paddle_R") as! SKSpriteNode;
        paddleR.PaddleNode.size.width	= CGFloat(PADDLE_WIDTH);
        paddleR.PaddleNode.size.height	= CGFloat(PADDLE_HEIGHT_MAX);
        paddleR.scoreObject = childNodeWithName("o_Screen_right_score") as! SKLabelNode;
        paddleR.livesObject = childNodeWithName("o_Screen_right_lives") as! SKLabelNode;
        
        INPUT_AREA_LEFT = childNodeWithName("o_Left_Paddle_Input") as! SKSpriteNode;
        INPUT_AREA_RIGHT = childNodeWithName("o_Right_Paddle_Input") as! SKSpriteNode;
        INPUT_AREA_LEFT.hidden = true;
        INPUT_AREA_RIGHT.hidden = true;
        
    }
    
//--------------------------------------------------------------------------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch(Gamestate){
        // MAIN MENU
        case 0:
            for touch in touches {
                let location = touch.locationInNode(self);
                if (location.x >= play_0.position.x && location.x <= play_0.position.x + play_0.size.width &&
                    location.y >= play_0.position.y && location.y <= play_0.position.y + play_0.size.height){
                        Gamestate = 1;
                        Gamemode = 0;
                        initt();
                }
                if (location.x >= play_1.position.x && location.x <= play_1.position.x + play_1.size.width &&
                    location.y >= play_1.position.y && location.y <= play_1.position.y + play_1.size.height){
                        Gamestate = 1;
                        Gamemode = 1;
                        initt();
                }
                if (location.x >= play_2.position.x && location.x <= play_2.position.x + play_2.size.width &&
                    location.y >= play_2.position.y && location.y <= play_2.position.y + play_2.size.height){
                        Gamestate = 1;
                        Gamemode = 2;
                        initt();
                }
            }
            break;
        // PLAY GAME
        case 1:
            for touch in touches {
                let location = touch.locationInNode(self);
                if (location.x >= pause_button.position.x && location.x <= pause_button.position.x + pause_button.size.width &&
                    location.y >= pause_button.position.y && location.y <= pause_button.position.y + pause_button.size.height){
                        Gamestate = 2;
                }
            }
            break;
        // PAUSE MENU
        case 2:
            for touch in touches {
                let location = touch.locationInNode(self);
                if (location.x >= pause_button.position.x && location.x <= pause_button.position.x + pause_button.size.width &&
                    location.y >= pause_button.position.y && location.y <= pause_button.position.y + pause_button.size.height){
                        Gamestate = 1;
                }
                if (location.x >= quit_button.position.x && location.x <= quit_button.position.x + quit_button.size.width &&
                    location.y >= quit_button.position.y && location.y <= quit_button.position.y + quit_button.size.height){
                        Gamestate = 0;
                }
            }
            break;
        default:
            return;
        }
    }
//--------------------------------------------------------------------------------------------------
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        switch (Gamestate){
        // MAIN MENU
        case 0:
            
            break;
            
            
        // PLAY GAME
        case 1:
            switch(Gamemode){
            case 0:
                return;
            case 1:
                for touch in touches { // that's stupid -_-
                    let location = touch.locationInNode(self);
                    paddleL.dy = Float(location.y);
                    
                    if (location.x >= pause_button.position.x && location.x <= pause_button.position.x + pause_button.size.width &&
                        location.y >= pause_button.position.y && location.y <= pause_button.position.y + pause_button.size.height){
                            Gamestate = 2;
                    }
                }
                return;
            case 2:
                for touch in touches {
                    let location = touch.locationInNode(self);
                    if(Float(location.x) < SCREEN_WIDTH/2){ // LEFT input
                        paddleL.dy = Float(location.y);
                    }else{									// RIGHT input
                        paddleR.dy = Float(location.y);
                    }
                    
                    if (location.x >= pause_button.position.x && location.x <= pause_button.position.x + pause_button.size.width &&
                        location.y >= pause_button.position.y && location.y <= pause_button.position.y + pause_button.size.height){
                            Gamestate = 2;
                    }
                }
                return;
            default:
                return;
            }
            
            
        // GAME PAUSED
        case 2:
            
            break;
        default:
            break;
        }
    }
    
//--------------------------------------------------------------------------------------------------
    override func update(currentTime: CFTimeInterval) {
        let delta: CFTimeInterval = currentTime - lastTime;
        lastTime = currentTime;
        
        if(delta > 1){
            return;
        }
        
        switch (Gamestate){
        case 0:
            if(pGamestate != Gamestate){
                // hide game
                paddleL.PaddleNode.hidden = true;
                paddleR.PaddleNode.hidden = true;
                ball.ballNode.hidden = true;
                
                // show menu
                play_0.hidden = false;
                play_1.hidden = false;
                play_2.hidden = false;
                label_0.hidden = false;
                label_1.hidden = false;
                label_2.hidden = false;
                
                // hide pause
                pause_button.hidden = true;
                pause_label.hidden = true;
                quit_button.hidden	= true;
                quit_label.hidden = true;
                
                pGamestate = Gamestate;
            }
            break;
        case 1:
            if(pGamestate != Gamestate){
                // show game
                paddleL.PaddleNode.hidden = false;
                paddleR.PaddleNode.hidden = false;
                ball.ballNode.hidden = false;
                
                // hide menu;
                play_0.hidden = true;
                play_1.hidden = true;
                play_2.hidden = true;
                label_0.hidden = true;
                label_1.hidden = true;
                label_2.hidden = true;
                
                // hide pause
                pause_button.hidden = false;
                pause_label.hidden = false;
                quit_button.hidden	= true;
                quit_label.hidden = true;
                
                pGamestate = Gamestate;
                
            }
            
            ball_update(Float(delta));
            ball_collision();
            paddle_update(Float(delta));
        	break;
        case 2:
            if(pGamestate != Gamestate){
                // show game
                paddleL.PaddleNode.hidden = false;
                paddleR.PaddleNode.hidden = false;
                ball.ballNode.hidden = false;
                
                // hide menu;
                play_0.hidden = true;
                play_1.hidden = true;
                play_2.hidden = true;
                label_0.hidden = true;
                label_1.hidden = true;
                label_2.hidden = true;
                
                // hide pause
                pause_button.hidden = false;
                pause_label.hidden = false;
                quit_button.hidden	= false;
                quit_label.hidden = false;
                
                pGamestate = Gamestate;
                
            }
            
            break;
        default:
            break;
        
        }
        
        if(paddleL.lives < 0 || paddleR.lives < 0){
            Gamestate = 0;
        }
        
        //debugLabel.text = "ball_pos : "+ball.x.description+" , "+ball.y.description+"\nball_angle : "+ball.angle.description;
    }
    
//--------------------------------------------------------------------------------------------------
    func ball_update(dt : Float){
        ball.dx = cos(degToRad(ball.angle)) * ball.speed * dt;
        ball.dy = sin(degToRad(ball.angle)) * ball.speed * dt;
        
        ball.x += ball.dx; ball.y += ball.dy;
        
        
        //== Update Object==//
        ball.ballNode.position.x = CGFloat(ball.x);
        ball.ballNode.position.y = CGFloat(ball.y);
    }
    
//--------------------------------------------------------------------------------------------------
    func ball_collision(){
        
        
        if(ball.x < BORDER_SIZE + BALL_SIZE/2){	//LEFT
            ball.x = BORDER_SIZE + BALL_SIZE/2;
            if(ball.y > paddleL.y + paddleL.height/2 + BALL_SIZE/2 || ball.y < paddleL.y - paddleL.height/2 - BALL_SIZE/2){
                //	MISSED
                paddleL.lives--;
                
                ball.x = SCREEN_WIDTH/2;
                ball.y = SCREEN_HEIGHT/2;
                if(ball.speed - 50 >= BALL_SPEED_MIN){
                    ball.speed -= 50;
                }else{
                    ball.speed = BALL_SPEED_MIN;
                }
            }else{
                // DIDNT MISS
                ball.angle = -calcBounceAngle( (ball.y - paddleL.y), paddle_height: paddleL.height);
                if(ball.speed + 10 <= BALL_SPEED_MAX){
                    ball.speed += 10;
                }else{
                    ball.speed = BALL_SPEED_MAX;
                }
                
                paddleL.score++;
                let randomAngle = Float(arc4random() % 90 + 1);
                paddleL.disToHitAngle = calcDisForAngle(randomAngle - 45, paddle_height: paddleL.height);
            }
        }else
        if(ball.x > SCREEN_WIDTH - BORDER_SIZE - BALL_SIZE/2){	//RIGHT
            ball.x = SCREEN_WIDTH - BORDER_SIZE - BALL_SIZE/2;
            if(ball.y > paddleR.y + paddleR.height/2 + BALL_SIZE/2 || ball.y < paddleR.y - paddleL.height/2 - BALL_SIZE/2){
                //	MISSED
                paddleR.lives--;
                
                ball.x = SCREEN_WIDTH/2;
                ball.y = SCREEN_HEIGHT/2;
                if(ball.speed - 50 >= BALL_SPEED_MIN){
                    ball.speed -= 50;
                }else{
                    ball.speed = BALL_SPEED_MIN;
                }
            }else{
                // DIDNT MISS
                ball.angle = 180 + calcBounceAngle( (ball.y - paddleR.y), paddle_height: paddleR.height);
                if(ball.speed + 10 <= BALL_SPEED_MAX){
                    ball.speed += 10;
                }
                
                paddleR.score++;
                let randomAngle = Float(arc4random() % 90 + 1);
                paddleR.disToHitAngle = calcDisForAngle(randomAngle - 45, paddle_height: paddleR.height);
            }
        }
        
        if(ball.y < BORDER_SIZE + MARGIN_SIZE + BALL_SIZE/2){	// BOT
            ball.angle *= -1;
            ball.y = BORDER_SIZE + MARGIN_SIZE + BALL_SIZE/2;
        }else
        if(ball.y > SCREEN_HEIGHT - BORDER_SIZE - BALL_SIZE/2){	//TOP
            ball.angle *= -1;
            ball.y = SCREEN_HEIGHT - BORDER_SIZE - BALL_SIZE/2;
        }
        
        if (ball.angle >= 360){
            ball.angle -= 360;
        }else
        if(ball.angle < 0){
            ball.angle += 360;
        }
    }

//--------------------------------------------------------------------------------------------------
    func paddle_update(dt : Float){
        
        switch (Gamemode){
        case 0:
            paddleL.dy = ball.y;
            paddleR.dy = ball.y;
            break;
        case 1:
            paddleL.disToHitAngle = 0;
        	paddleR.dy = ball.y;
        	break;
        case 2:
            paddleL.disToHitAngle = 0;
            paddleR.disToHitAngle = 0;
            break;
        default:
            break;
        }
        
        paddleL.y += (paddleL.dy - (paddleL.y + paddleL.disToHitAngle))/2;
        paddleR.y += (paddleR.dy - (paddleR.y + paddleR.disToHitAngle))/2;
        
        debugBall.position.y = CGFloat(paddleR.y + paddleR.disToHitAngle);
        
        
        //== Clamp Paddles ==//
        if(paddleL.y > SCREEN_HEIGHT - BORDER_SIZE - paddleL.height/2){
            paddleL.y = SCREEN_HEIGHT - BORDER_SIZE - paddleL.height/2;
        }else
        if(paddleL.y < BORDER_SIZE + MARGIN_SIZE + paddleL.height/2){
            paddleL.y = BORDER_SIZE + MARGIN_SIZE + paddleL.height/2;
        }
        if(paddleR.y > SCREEN_HEIGHT - BORDER_SIZE - paddleR.height/2){
            paddleR.y = SCREEN_HEIGHT - BORDER_SIZE - paddleR.height/2;
        }else
        if(paddleR.y < BORDER_SIZE + MARGIN_SIZE + paddleR.height/2){
            paddleR.y = BORDER_SIZE + MARGIN_SIZE + paddleR.height/2;
        }
        
        //== Update Stats ==//
        paddleL.scoreObject.text = paddleL.score.description;
        paddleL.livesObject.text = paddleL.lives.description;
        
        paddleR.scoreObject.text = paddleR.score.description;
        paddleR.livesObject.text = paddleR.lives.description;
        
        
        //== Update Object ==//
        paddleL.PaddleNode.size.height = CGFloat(paddleL.height);
        paddleR.PaddleNode.size.height = CGFloat(paddleR.height);
        paddleL.PaddleNode.position.x = CGFloat(paddleL.x);
        paddleR.PaddleNode.position.x = CGFloat(paddleR.x);
        paddleL.PaddleNode.position.y = CGFloat(paddleL.y);
        paddleR.PaddleNode.position.y = CGFloat(paddleR.y);
    }
    
//--------------------------------------------------------------------------------------------------
    func calcBounceAngle(dis : Float, paddle_height : Float) -> Float{
        let maxDis = (paddle_height + BALL_SIZE - 2)/2
        let m = -60 / maxDis;
        return m * dis;
	}
    
//--------------------------------------------------------------------------------------------------
    func calcDisForAngle(angle : Float, paddle_height : Float) -> Float{
        let maxDis = (paddle_height + BALL_SIZE - 2)/2
        let m = -60 / maxDis;
        return angle / m;
    }
    
    
//--------------------------------------------------------------------------------------------------
    func degToRad(angle : Float) -> Float{
        return angle * ((22/7)/180);
    }
}


































