import SpriteKit

class Scene2: SKScene {
    override func didMove(to view: SKView) {
        
        //Background:
        let backgroundImage = SKSpriteNode(imageNamed: "bg2")
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.zPosition = -1
        
        addChild(backgroundImage)
    }
}
