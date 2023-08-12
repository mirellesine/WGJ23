import SpriteKit

class MenuScene: SKScene {
    
    private var background: SKSpriteNode!
    private var nome: SKLabelNode!
    private var iniciar: SKLabelNode!
    private var credits: SKLabelNode!
    
    private var balloon: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
        if let label = childNode(withName: "iniciar") as? SKLabelNode, label.contains(location) {
            if let gameScene = GameScene(fileNamed: "GameScene") {
                gameScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(gameScene, transition: transition)
            }
        }
        
        if let label = childNode(withName: "credits") as? SKLabelNode, label.contains(location) {
            if let infoScene = InfoScene(fileNamed: "InfoScene") {
                infoScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(infoScene, transition: transition)
            }
        }
    }
}
