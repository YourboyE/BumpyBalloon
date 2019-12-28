//
//  GameScene.swift
//  BumpyBalloon
//
//  Created by YBE on 12/27/19.
//  Copyright © 2019 DreamDev. All rights reserved.
//

import SpriteKit
import GameplayKit

@objcMembers
class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "balloon")
    
    var timer: Timer?
    
    override func didMove(to view: SKView) {
        
        //player details
        player.setScale(0.5)
        player.zPosition = 1
        player.position = CGPoint(x: -300, y: 130)
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2.5)
        
        //adding gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        
        parallaxScroll(image: "sky", y: 0, z: -3, duration: 10, needsPhyics: false)
        parallaxScroll(image: "ground", y: -165, z: -1, duration: 6, needsPhyics: true)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // to give "pulling up" look
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
    }
    
    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhyics: Bool) {
        
        // run this code twice
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            
            // position the first node on the left, and position the second on the right
            node.position = CGPoint(x: 1023 * CGFloat(i), y: y)
            node.zPosition = z
            addChild(node)
            
            //make this node move the width of the screen by whatever duration was passed in
            let move = SKAction.moveBy(x: -1024, y: 0, duration: duration)
            
            // make it jump back to the right edge
            let wrap = SKAction.moveBy(x: 1024, y: 0, duration: 0)
            
            //make these two as a sequence that loops forever
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
            
            //run the animations
            node.run(forever)
        }
        
    }
    
    
    func createPillar() {
        
        let topPillar = SKSpriteNode(imageNamed: "enemy-ground-hi")
        topPillar.zPosition = -2
        topPillar.position.x = 400
        addChild(topPillar)
        
        let bottomPillar = SKSpriteNode(imageNamed: "enemy-ground-lo")
        bottomPillar.zPosition = -2
        bottomPillar.position.x = topPillar.position.x
        addChild(bottomPillar)
    
        //decide where to create it
        let rand = GKRandomDistribution(lowestValue: -110, highestValue: 110)
        topPillar.position.y = CGFloat(rand.nextInt())
        bottomPillar.position.y = topPillar.position.y - 5
        
        //make it move across the screen
        let action = SKAction.moveTo(x: -700, duration: 8)
        topPillar.run(action)
        bottomPillar.run(action)
    }
    
    
    func createObstacle() {
        
        //create and postion the ground, choosing either high or low to make the player dodge them
        let options = ["enemy-ground-lo", "enemy-ground-hi"]
        let chosen = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
        let obstacle = SKSpriteNode(imageNamed: options[chosen])
        obstacle.zPosition = -2
        obstacle.position.x = 400
        addChild(obstacle)
        
        //decide where to create it
        let rand = GKRandomDistribution(lowestValue: -90, highestValue: 100)
        obstacle.position.y = CGFloat(rand.nextInt())
        
        //make it move across the screen
        let action = SKAction.moveTo(x: -700, duration: 9)
        obstacle.run(action)
    }
    
}

