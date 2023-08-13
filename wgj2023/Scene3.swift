//
//  Scene3.swift
//  wgj2023
//
//  Created by Mirelle Sine on 12/08/23.
//

import Foundation
import SpriteKit

class Scene3: SKScene {
    override func didMove(to view: SKView) {
        
        //Background:
        let backgroundImage = SKSpriteNode(imageNamed: "bg2")
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.zPosition = -1
        
        addChild(backgroundImage)
    }
}
