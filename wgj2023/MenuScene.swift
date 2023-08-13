import AVFoundation
import SpriteKit

class MenuScene: SKScene {
    private var background: SKSpriteNode!
    private var predio: SKSpriteNode!
    private var nome: SKLabelNode!
    private var iniciar: SKLabelNode!
    private var credits: SKLabelNode!
    
    override func didMove(to view: SKView) {
        // Reproduz a música
        SoundDesign.shared.playBackgroundMusic(filename: "game-music.mp3")
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        // Checa o label clicado e muda pra game scene
        if let label = childNode(withName: "iniciar") as? SKLabelNode, label.contains(location) {
            if let gameScene = SKScene(fileNamed: "GameScene") {
                gameScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
        // Checa o label clicado e muda pra cena de créditos
        if let label = childNode(withName: "credits") as? SKLabelNode, label.contains(location) {
            if let infoScene = InfoScene(fileNamed: "InfoScene") {
                infoScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(infoScene, transition: transition)
            }
        }
    }
}


class SoundDesign {
    static let shared = SoundDesign()
    private var backgroundMusicPlayer: AVAudioPlayer? // Reprodutor de música de fundo
    
    private init() {}

    // Função para adicionar uma música de fundo
    func playBackgroundMusic(filename: String) {
        guard let music = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Arquivo da música de fundo não encontrado.")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: music) // Inicializa o reprodutor com o URL do arquivo de música
            backgroundMusicPlayer?.numberOfLoops = -1 // Coloca a música em loop infinito
            backgroundMusicPlayer?.volume = 0.5 // Volume da música em 50%
            backgroundMusicPlayer?.play() // Inicia a música
            
        } catch {
            print("Erro ao reproduzir a música de fundo: \(error.localizedDescription)")
        }
    }
}
