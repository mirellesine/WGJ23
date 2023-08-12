import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var character: SKSpriteNode!
    private var balloon: SKSpriteNode?
    private var arrow: SKSpriteNode?
    private var balloonDisplayed = false

    
    override func didMove(to view: SKView) {
        
        let backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundImage.zPosition = -1
        // Aspect ratio do background:
        let widthScale = self.frame.width / backgroundImage.size.width
        let heightScale = self.frame.height / backgroundImage.size.height
        let scaleFactor = max(widthScale, heightScale)
        backgroundImage.setScale(scaleFactor)
        addChild(backgroundImage)
        
        // Adiciona o "personagem" (asset clicável)
        character = SKSpriteNode(imageNamed: "treeSmall_green2")
        character.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(character)
    }
    
    // Checa o click
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
        // Se o personagem tá na localização do click:
        if character.contains(location) && !balloonDisplayed {
            // Mostra o balão
            let balloonTexture = SKTexture(imageNamed: "balloon")
            balloon = SKSpriteNode(texture: balloonTexture)
            balloon!.position = CGPoint(x: character.position.x, y: character.position.y + character.size.height / 2 + balloon!.size.height / 2)
            addChild(balloon!)
            
            // Mostrar a setinha pra próxima cena depois de 2 segundos:
            let waitAction = SKAction.wait(forDuration: 2)
            let showArrowAction = SKAction.run {
                self.showArrow()
            }
            let sequence = SKAction.sequence([waitAction, showArrowAction])
            run(sequence)
            
            balloonDisplayed = true
        }
    }
    
    // Adiciona a setinha:
    func showArrow() {
        let arrowTexture = SKTexture(imageNamed: "arrow")
        arrow = SKSpriteNode(texture: arrowTexture)
        arrow!.position = CGPoint(x: self.frame.midX + 200, y: self.frame.minY + 60)
        arrow!.size = CGSize(width: 50, height: 50)
        addChild(arrow!)
    }

    // Registra o final do click:
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        
        if let arrow = arrow, arrow.contains(location) {
            let transition = SKTransition.fade(withDuration: 0.5)
            let nextScene = Scene2(size: self.size)
            self.view?.presentScene(nextScene, transition: transition)
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Atualiza a página a cada frame
    }
}
