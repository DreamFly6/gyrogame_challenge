//
//  GameScene.swift
//  GyroGame
//
//  Created by Emilian Brenici on 02/10/2021.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    private var motionManager: CMMotionManager!
    private var playerNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        loadScene()
        startMotionManager()
    }
    
    private func loadScene() {
        addSceneBackground()
        createPlayer()
    }
    
    private func startMotionManager() {
        motionManager = CMMotionManager()
        guard motionManager.isAccelerometerAvailable else {
            return
        }
        motionManager.startAccelerometerUpdates()
    }
    
    private func createPlayer() {
        playerNode = SKSpriteNode(imageNamed: "ball")
        playerNode.position = CGPoint(x: 555, y: -372)
        playerNode.size = CGSize(width: 80, height: 80)
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.density = 7.0               // real steel ball density
        playerNode.physicsBody?.linearDamping = 0.4         // increased friction
        playerNode.physicsBody?.restitution = 0.3           // increased restitution
        playerNode.physicsBody?.categoryBitMask = 1
        playerNode.physicsBody?.contactTestBitMask = 2 | 3  // holes and finish
        playerNode.physicsBody?.collisionBitMask = 2        // walls
        playerNode.zPosition = 1                            // in front of all nodes
        addChild(playerNode)
    }
    
    private func addSceneBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.zPosition = -1
        addChild(background)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(
                dx: accelerometerData.acceleration.y * -98,
                dy: accelerometerData.acceleration.x * 98)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == playerNode {
            if let nodeB = contact.bodyB.node {
                playerContacted(with: nodeB)
            }
        } else if contact.bodyB.node == playerNode {
            if let nodeA = contact.bodyA.node {
                playerContacted(with: nodeA)
            }
        }
    }
    
    private func playerContacted(with node: SKNode) {
        if node.name == "holeNode" { // trap
            // hole contacted method
            // ball animation
            // restart game
            print("contacted hole :(")
        } else if node.name == "finishNode" { // finish
            print("contacted finish :)")
            // finish contacted method
            // ball animation
            // restart game
        } else { // wall
            print("wall")
            // haptic feedback?
        }
    }

}
