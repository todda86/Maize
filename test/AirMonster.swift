//
//  AirMonster.swift
//  test
//
//  Created by Anderson, Todd W. on 4/23/17.
//  Copyright © 2017 Anderson, Todd W. All rights reserved.
//

import Foundation
import SpriteKit

class AirMonster: Monster {
    var x: Double
    var y: Double
    var node: SKNode
    var scene: GameScene?
    var tileSize: Double
    var callIndex: Int = 0
    var callRate: Int
    var speed: Double
    var momX: Double = 0
    var momY: Double = 0
    
    //called to create an AirMonster
    required init(x: Double, y: Double, speed: Double, scene: GameScene) {
        //sets attributes based on arguments
        self.x = x
        self.y = y
        self.callRate = Int(60 * speed)
        self.scene = scene
        tileSize = (scene.tileSize)
        node = SKShapeNode()
        node.zPosition = 30
        let path = UIBezierPath()
        //makes triangle node at specified point
        path.move(to: CGPoint(x: tileSize * -1/3, y: tileSize * -1/3))
        path.addLine(to: CGPoint(x: tileSize * 1/3, y: tileSize * -1/3))
        path.addLine(to: CGPoint(x: 0.0, y: tileSize * 1/3))
        (node as? SKShapeNode)?.path = path.cgPath
        (node as! SKShapeNode).fillColor = UIColor.red
        node.zPosition = 5
        let difX = (Int(x) - (scene.tileX)) * Int(tileSize)
        let difY = (Int(y) - (scene.tileY)) * Int(tileSize)
        node.position.x = CGFloat(difX)
        node.position.y = CGFloat(difY)
        
        //adds node to scene
        scene.addChild(node)
        self.speed = speed
    }
    
    //moves the monster in accordance with players input
    func playerMove(direction: Int) {
        switch direction {
        case 0:
            node.run(SKAction.moveBy(x: CGFloat(0), y: CGFloat(-1 * tileSize), duration: 1/3))
        case 1:
            node.run(SKAction.moveBy(x: CGFloat(-1 * tileSize), y: CGFloat(0), duration: 1/3))
        case 2:
            node.run(SKAction.moveBy(x: CGFloat(0), y: CGFloat(tileSize), duration: 1/3))
        case 3:
            node.run(SKAction.moveBy(x: CGFloat(tileSize), y: CGFloat(0), duration: 1/3))
        default:
            break
        }
    }
    
    //required method that moves the monster
    func move() {
        //if the monster and the player occupy the same space fail the level
        if (abs(node.position.x) <= CGFloat(tileSize * 2/3) && abs(node.position.y) <= CGFloat(tileSize * 2/3)) {
            scene?.controller?.failLevel()
        }
        //if the wait time has elapse change the monsters direction
        callIndex += 1
        if (callIndex >= callRate) {
            callIndex = 0
            evaluate()
            node.run(SKAction.move(by: CGVector.init(dx: momX, dy: momY), duration: speed))
        }
    }
    
    //changes the monsters momentum slightly
    func evaluate() {
        momX += Double(arc4random_uniform(UInt32(tileSize / 3))) - (tileSize / 6)
        momY += Double(arc4random_uniform(UInt32(tileSize / 3))) - (tileSize / 6)
    }
    
    //removes the monster
    func remove() {
        node.removeFromParent()
    }
    
    //returns an identical copy of the monster
    func copy() -> Monster {
        return AirMonster(x: x, y: y, speed: speed, scene: scene!)
    }
}
