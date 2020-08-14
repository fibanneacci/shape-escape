import Foundation
import PlaygroundSupport
import SpriteKit

public class Splash: SKScene {
    
    public override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.setScale(1.5)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(background)
        
        let label1 = SKLabelNode(fontNamed: "San Francisco")
        label1.text = "welcome to"
        label1.fontSize = 36
        label1.fontColor = SKColor.blue
        label1.position = CGPoint(x: self.frame.midX, y: 480)
        let label2 = SKLabelNode(fontNamed: "San Francisco")
        label2.text = "SHAPE ESCAPE!"
        label2.fontSize = 36
        label2.fontColor = SKColor.blue
        label2.position = CGPoint(x: self.frame.midX, y: 420)
        let label3 = SKLabelNode(fontNamed: "San Francisco")
        label3.text = "an introduction to BFS/DFS"
        label3.fontSize = 30
        label3.fontColor = SKColor.black
        label3.position = CGPoint(x: self.frame.midX, y: 360)
        addChild(label1)
        addChild(label2)
        addChild(label3)
        
        //let button = SKSpriteNode(color: SKColor.black, size: CGSize(width: 100, height: 48))
        let button = SKShapeNode(rectOf: CGSize(width: 125, height: 48), cornerRadius: 10)
        button.fillColor = SKColor.black
        button.position = CGPoint(x: self.frame.midX, y: 280)
        button.name = "button"
        let label4 = SKLabelNode(fontNamed: "San Francisco")
        label4.text = "START"
        label4.fontSize = 30
        label4.fontColor = SKColor.white
        label4.position = CGPoint(x: self.frame.midX, y: 270)
        label4.name = "label"
        
        addChild(button)
        addChild(label4)
        
        let trianglePlayer = SKSpriteNode(imageNamed: "triangle.png")
        trianglePlayer.name = "trianglePlayer"
        trianglePlayer.setScale(1.0)
        trianglePlayer.position = CGPoint(x: 120, y: 225)
        self.addChild(trianglePlayer)
        let circlePlayer = SKSpriteNode(imageNamed: "circle.png")
        circlePlayer.name = "circlePlayer"
        circlePlayer.setScale(1.0)
        circlePlayer.position = CGPoint(x: 360, y: 200)
        self.addChild(circlePlayer)
    }
    
    public func touchDown(atPoint pos : CGPoint) {
        let node = atPoint(pos)
        let name = node.name
        if (name == "button" || name == "label") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let bfs = bfsScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(bfs, transition: trans)
        }
    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    public func touchUp(atPoint pos : CGPoint) {
        /*if (pos.x >= 190 && pos.x <= 290 && pos.y >= 154 && pos.y <= 202) {
            let trans = SKTransition.crossFade(withDuration: 0.5)
            let bfs = bfsScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(bfs, transition: trans) //unwrap?
        }*/
    }
    
    public override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    
    public override func mouseDragged(with event: NSEvent) {
        touchMoved(toPoint: event.location(in: self))
    }
    
    public override func mouseUp(with event: NSEvent) {
        touchUp(atPoint: event.location(in: self))
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
