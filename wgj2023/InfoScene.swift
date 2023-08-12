import SpriteKit

class InfoScene: SKScene {
    
    private var background: SKSpriteNode!
    private var retornar: SKLabelNode!
    
    private var amanda: SKLabelNode!
    private var nina: SKLabelNode!
    private var jubs: SKLabelNode!
    private var maria: SKLabelNode!
    private var yasmin: SKLabelNode!
    private var mirelle: SKLabelNode!
    private var thayna: SKLabelNode!

    private var amanda_role: SKLabelNode!
    private var nina_role: SKLabelNode!
    private var jubs_role: SKLabelNode!
    private var maria_role: SKLabelNode!
    private var yasmin_role: SKLabelNode!
    private var mirelle_role: SKLabelNode!
    private var thayna_role: SKLabelNode!
    

    override func didMove(to view: SKView) {

    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
        if let label = childNode(withName: "retornar") as? SKLabelNode, label.contains(location) {
            if let menuScene = MenuScene(fileNamed: "MenuScene") {
                menuScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(menuScene, transition: transition)
            }
        }
    }
}
