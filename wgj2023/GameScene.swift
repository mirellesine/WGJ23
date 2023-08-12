import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var character: SKSpriteNode!
    private var balloon: SKSpriteNode?
    private var arrow: SKSpriteNode?
    private var polaroid: SKSpriteNode!
    private var polaroidContainer: SKNode!
    private var backgroundImage: SKSpriteNode!
    private var balloonDisplayed = false
    
    // Ação para fazer a polaroid tremer.
    let shake = SKAction.sequence([
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5),
        SKAction.rotate(byAngle: .pi/6, duration: 0.5),
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5)
    ])
    
    let wait = SKAction.wait(forDuration: 1.5)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        character = childNode(withName: "character") as? SKSpriteNode
        polaroid = childNode(withName: "polaroid") as? SKSpriteNode
        polaroidContainer = childNode(withName: "polaroidContainer")
    }
    
    
    override func didMove(to view: SKView) {
        itemDetail()
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
            polaroid?.run(shake)
            
            // Mostrar a setinha pra próxima cena depois de 1 segundos:
            let waitAction = SKAction.wait(forDuration: 2.5)
            
            run(waitAction, completion: {let nextScene = Scene2(size: self.size)
                self.view?.presentScene(nextScene)})
            
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
    
    func itemDetail() {
        let newSize: CGFloat = 400
        let resize = SKAction.resize(toWidth: newSize, height: newSize, duration: 1)
        let position = polaroidContainer.position
        let targetPosition = CGPoint(x: position.x - newSize / 4, y: position.y + newSize / 2)
        let move = SKAction.move(to: targetPosition, duration: 0.5)
        let sequence = SKAction.sequence([wait, move, resize])
        polaroid?.run(sequence)
        polaroid.addBlur()
        
    }

    // Registra o final do click:
    override func mouseUp(with event: NSEvent) {
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Atualiza a página a cada frame
    }
}

extension SKSpriteNode {
    func addBlur() {
        let blurEffectNode = SKEffectNode()
        addChild(blurEffectNode)
        let effect = SKSpriteNode(texture: texture)
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        let blurRadius: CGFloat = 100.0
        effect.size = self.size
        blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        blurEffectNode.filter = blurFilter
        blurEffectNode.addChild(effect)
        blurEffectNode.filter = CIFilter(name: "CIGaussianBlur")
    }
}
//extension SKSpriteNode {
//    func addGlow(radius: Float) {
//        let effectNode = SKEffectNode()
//        effectNode.shouldRasterize = true
//        addChild(effectNode)
//        let effect = SKSpriteNode(texture: texture)
//        effect.color = .white
//        effect.size = self.size
//        effect.colorBlendFactor = 1
//        effectNode.addChild(effect)
//        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
//    }
