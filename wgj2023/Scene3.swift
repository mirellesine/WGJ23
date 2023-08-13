import SpriteKit
import GameplayKit

class Scene3: SKScene {
    private var character: SKSpriteNode!
    private var balloon: SKSpriteNode?
    private var polaroid: SKSpriteNode!
    private var polaroidContainer: SKNode!
    private var backgroundImage: SKSpriteNode!
    private var balloonDisplayed = false
    private var isPolaroidClickable = false
    
    // -------- Substituir esses nodes depois:
    private var node1: SKSpriteNode!
    private var node2: SKSpriteNode!
    private var node3: SKSpriteNode!
    private var node4: SKSpriteNode!
    private var node5: SKSpriteNode!


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
        
        // -------- Substituir esses nodes depois
        node1 = childNode(withName: "node1") as? SKSpriteNode
        node2 = childNode(withName: "node2") as? SKSpriteNode
        node3 = childNode(withName: "node3") as? SKSpriteNode
        node4 = childNode(withName: "node4") as? SKSpriteNode
        node5 = childNode(withName: "node5") as? SKSpriteNode
    }
    
    
    override func didMove(to view: SKView) {
        itemDetail()
        let passaros = SKAudioNode(fileNamed: "birds-chirping.mp3")
        self.addChild(passaros)
    }
    
    // Checa o click
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
        // Se o personagem certo tá na localização do click:
        if character.contains(location) && !balloonDisplayed {
            
            let soundAction = SKAction.playSoundFileNamed("pigeon.mp3", waitForCompletion: false)

            // Mostra o balão de confirmação
            let balloonTexture = SKTexture(imageNamed: "balloon")
            balloon = SKSpriteNode(texture: balloonTexture)
            balloon!.position = CGPoint(x: character.position.x, y: character.position.y + character.size.height / 2 + balloon!.size.height / 2)
            addChild(balloon!)
            
            // Remove o blur da polaroid
            let removeBlur = SKAction.run {
                self.polaroid.removeFromParent()
                self.addChild(self.polaroid)
            }
            
            // Mostrar a próxima cena depois de 2.5 segundos:
            let waitBeforeTransition = SKAction.wait(forDuration: 2.5)
            let transitionAction = SKAction.run {
                let newScene = SKScene(fileNamed: "InfoScene")
                newScene?.scaleMode = .aspectFit
                self.view?.presentScene(newScene)
            }
            
            // Sacode a polaroid pra indicar que acertou e muda de cena
            let sequence = SKAction.sequence([soundAction, removeBlur, shake, waitBeforeTransition, transitionAction])
            polaroid.run(sequence)
                                    
            balloonDisplayed = true
        }
        
        if polaroid.contains(location) && isPolaroidClickable {
            itemDetail()
            isPolaroidClickable = false
        }
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
    
    // Checa os cliques dos objetos clicáveis no cenário e adiciona áudio
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        if node1.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("chucke.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if node2.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("pigeon.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if node3.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("cat.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if node4.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("dog.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if node5.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("paper.mp3", waitForCompletion: false)
            self.run(soundAction)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Atualiza a página a cada frame
    }
}
