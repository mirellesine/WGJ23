import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var character: SKSpriteNode!
    private var balloon: SKSpriteNode?
    private var polaroid: SKSpriteNode!
    private var polaroidContainer: SKNode!
    private var backgroundImage: SKSpriteNode!
    private var balloonDisplayed = false
    private var isPolaroidClickable = false
    
    // -------- Substituir esses nodes depois:
    private var colombiana: SKSpriteNode!
    private var pombo: SKSpriteNode!
    private var gato: SKSpriteNode!
    private var cachorro: SKSpriteNode!
    private var mulherJornal: SKSpriteNode!
    private var flor: SKSpriteNode!
    private var mulherFoto: SKSpriteNode!

    // Ação para fazer a polaroid tremer.
    let shake = SKAction.sequence([
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5),
        SKAction.rotate(byAngle: .pi/6, duration: 0.5),
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5)
    ])
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        polaroid = childNode(withName: "polaroid") as? SKSpriteNode
        polaroidContainer = childNode(withName: "polaroidContainer")
        
        // -------- Substituir esses nodes depois
        colombiana = childNode(withName: "colombiana") as? SKSpriteNode
        pombo = childNode(withName: "pombo") as? SKSpriteNode
        gato = childNode(withName: "gato") as? SKSpriteNode
        cachorro = childNode(withName: "cachorro") as? SKSpriteNode
        mulherJornal = childNode(withName: "mulherJornal") as? SKSpriteNode
        flor = childNode(withName: "flor") as? SKSpriteNode
        mulherFoto = childNode(withName: "mulherFoto") as? SKSpriteNode
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
        if cachorro.contains(location) && !balloonDisplayed {
            
            let soundAction = SKAction.playSoundFileNamed("dog.mp3", waitForCompletion: false)

            // Mostra o balão de confirmação
            let balloonTexture = SKTexture(imageNamed: "balloon")
            balloon = SKSpriteNode(texture: balloonTexture)
            balloon!.position = CGPoint(x: cachorro.position.x, y: cachorro.position.y + cachorro.size.height / 2 + balloon!.size.height / 2)
            balloon?.zPosition = 2
            addChild(balloon!)
            
            // Remove o blur da polaroid
            let removeBlur = SKAction.run {
                self.polaroid.removeFromParent()
                self.addChild(self.polaroid)
            }
            
            // Mostrar a próxima cena depois de 2.5 segundos:
            let waitBeforeTransition = SKAction.wait(forDuration: 2.5)
            let transitionAction = SKAction.run {
                let newScene = SKScene(fileNamed: "Scene2")
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
        let resizeBig = SKAction.scale(to: 1.5, duration: duration)
        
        let center = CGPoint(x: 0, y: 0)
        let moveToCenter = SKAction.move(to: center, duration: duration)
        
        let removeBlur = SKAction.run {
            self.polaroid.removeFromParent()
            self.addChild(self.polaroid)
        }
        
        //polaroid vai pro centro
        let centerAction = SKAction.group([resizeBig, moveToCenter, removeBlur])
        
        //polaroid diminui
        let resizeSmall = SKAction.scale(to: 0.5, duration: duration)
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
                        effectNode.zPosition = 3
            //thread
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) { [weak self] in
                self?.isPolaroidClickable = true
            }
        })
    }
    
    // Checa os cliques dos objetos clicáveis no cenário e adiciona áudio
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        if colombiana.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("chucke.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if pombo.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("pigeon.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if gato.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("cat.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if mulherFoto.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)
            self.run(soundAction)
        } else if mulherJornal.contains(location) && !balloonDisplayed {
            let soundAction = SKAction.playSoundFileNamed("paper.mp3", waitForCompletion: false)
            self.run(soundAction)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Atualiza a página a cada frame
    }
}
