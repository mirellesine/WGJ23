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
    private var isPolaroidClickable = false
    
    // Ação para fazer a polaroid tremer.
    let shake = SKAction.sequence([
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5),
        SKAction.rotate(byAngle: .pi/6, duration: 0.5),
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5)
    ])
    
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
            
            let removeBlur = SKAction.run {
                self.polaroid.removeFromParent()
                self.addChild(self.polaroid)
            }
            
            let sequence = SKAction.sequence([removeBlur, shake])
            polaroid.run(sequence)
            
            // Mostrar a setinha pra próxima cena depois de 1 segundos:
            let waitAction = SKAction.wait(forDuration: 2.5)
            
            run(waitAction)//: {
//                let nextScene = Scene2(size: self.size)
//                self.view?.presentScene(nextScene)
//
//            })
            
            balloonDisplayed = true
        }
        
        if polaroid.contains(location) && isPolaroidClickable {
            itemDetail()
            isPolaroidClickable = false
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
        let wait = SKAction.wait(forDuration: 1.5)
        
        let duration: TimeInterval = 1
        //polaroid aumenta
        let resizeBig = SKAction.scale(to: 0.4, duration: duration)
        
        
        let center = CGPoint(x: 0, y: 0)
        let moveToCenter = SKAction.move(to: center, duration: duration)
        
        let removeBlur = SKAction.run {
            self.polaroid.removeFromParent()
            self.addChild(self.polaroid)
        }
        
        //polaroid vai pro centro
        let centerAction = SKAction.group([resizeBig, moveToCenter, removeBlur])
        
        //polaroid diminui
        let resizeSmall = SKAction.scale(to: 0.2, duration: duration)
        //posiçao do nó transparente
        let targetPosition = CGPoint(x: polaroidContainer.position.x, y: polaroidContainer.position.y)
        
        let moveToCorner = SKAction.move(to: targetPosition, duration: duration)
        //polaroid vai pra borda
        let cornerAction = SKAction.group([resizeSmall, moveToCorner])
        
        //sequencia de actions
        let sequence = SKAction.sequence([centerAction, wait, cornerAction])
        
        polaroid?.run(sequence, completion: {
            let effectNode = SKEffectNode()
                        let filter = CIFilter(name: "CIGaussianBlur")
                        let radius = 5.0
                        filter?.setValue(radius, forKey: kCIInputRadiusKey)
                        effectNode.filter = filter
                        self.polaroid.removeFromParent()
                        effectNode.addChild(self.polaroid)
                        self.addChild(effectNode)
            //thread
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) { [weak self] in
                self?.isPolaroidClickable = true
            }
        })
    }
    override func update(_ currentTime: TimeInterval) {
        // Atualiza a página a cada frame
    }
}
