import Foundation
import PlaygroundSupport
import SpriteKit

var len: Int = 0
var wid: Int = 0

public class Menu: SKScene {
    
    public override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.setScale(1.5)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(background)
        
        let label1 = SKLabelNode(fontNamed: "San Francisco")
        label1.text = "HOORAY!"
        label1.fontSize = 18
        label1.fontColor = SKColor.blue
        label1.position = CGPoint(x: self.frame.midX, y: 600)
        let label2 = SKLabelNode(fontNamed: "San Francisco")
        label2.text = "You're ready to try some mazes on your own."
        label2.fontSize = 18
        label2.fontColor = SKColor.blue
        label2.position = CGPoint(x: self.frame.midX, y: 570)
        let label3 = SKLabelNode(fontNamed: "San Francisco")
        label3.text = "Don't forget to check out the Grand Finale!"
        label3.fontSize = 18
        label3.fontColor = SKColor.blue
        label3.position = CGPoint(x: self.frame.midX, y: 540)
        addChild(label1)
        addChild(label2)
        addChild(label3)
        
        let button5 = SKShapeNode(rectOf: CGSize(width: 100, height: 36), cornerRadius: 10)
        button5.fillColor = SKColor.black
        button5.position = CGPoint(x: 240, y: 480)
        button5.name = "button5"
        let label5 = SKLabelNode(fontNamed: "San Francisco")
        label5.text = "5 x 5"
        label5.fontSize = 18
        label5.fontColor = SKColor.white
        label5.position = CGPoint(x: self.frame.midX, y: 475)
        label5.name = "label5"
        addChild(button5)
        addChild(label5)
        let button6 = SKShapeNode(rectOf: CGSize(width: 100, height: 36), cornerRadius: 10)
        button6.fillColor = SKColor.black
        button6.position = CGPoint(x: self.frame.midX, y: 420)
        button6.name = "button6"
        let label6 = SKLabelNode(fontNamed: "San Francisco")
        label6.text = "6 x 6"
        label6.fontSize = 18
        label6.fontColor = SKColor.white
        label6.position = CGPoint(x: self.frame.midX, y: 415)
        label6.name = "label6"
        addChild(button6)
        addChild(label6)
        let button7 = SKShapeNode(rectOf: CGSize(width: 100, height: 36), cornerRadius: 10)
        button7.fillColor = SKColor.black
        button7.position = CGPoint(x: self.frame.midX, y: 360)
        button7.name = "button7"
        let label7 = SKLabelNode(fontNamed: "San Francisco")
        label7.text = "7 x 7"
        label7.fontSize = 18
        label7.fontColor = SKColor.white
        label7.position = CGPoint(x: self.frame.midX, y: 355)
        label7.name = "label7"
        addChild(button7)
        addChild(label7)
        let grandButton = SKShapeNode(rectOf: CGSize(width: 225, height: 36), cornerRadius: 10)
        grandButton.fillColor = SKColor.black
        grandButton.position = CGPoint(x: self.frame.midX, y: 300)
        grandButton.name = "grandButton"
        let grandLabel = SKLabelNode(fontNamed: "San Francisco")
        grandLabel.text = "GRAND FINALE"
        grandLabel.fontSize = 18
        grandLabel.fontColor = SKColor.white
        grandLabel.position = CGPoint(x: self.frame.midX, y: 295)
        grandLabel.name = "grandLabel"
        addChild(grandButton)
        addChild(grandLabel)
        
        let trianglePlayer = SKSpriteNode(imageNamed: "triangle.png")
        trianglePlayer.name = "trianglePlayer"
        trianglePlayer.setScale(1.0)
        trianglePlayer.position = CGPoint(x: 120, y: 165)
        self.addChild(trianglePlayer)
        let circlePlayer = SKSpriteNode(imageNamed: "circle.png")
        circlePlayer.name = "circlePlayer"
        circlePlayer.setScale(1.0)
        circlePlayer.position = CGPoint(x: 360, y: 140)
        self.addChild(circlePlayer)
        
        let backButton = SKShapeNode(rectOf: CGSize(width: 125, height: 30), cornerRadius: 8)
        backButton.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        backButton.position = CGPoint(x: 72, y: 25)
        backButton.name = "backButton"
        let backLabel = SKLabelNode(fontNamed: "San Francisco")
        backLabel.fontColor = SKColor.white
        backLabel.text = "< back to tutorial"
        backLabel.fontSize = 14
        backLabel.position = CGPoint(x: 72, y: 20)
        backLabel.name = "backLabel"
        addChild(backButton)
        addChild(backLabel)
    }
    
    public func touchDown(atPoint pos : CGPoint) {
        let node = atPoint(pos)
        let name = node.name
        if (name == "backButton" || name == "backLabel") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            let dir = SKTransitionDirection(rawValue: 2)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let dfs = dfsScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(dfs, transition: trans)
        }
        if (name == "button5" || name == "label5") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            len = 5
            wid = 5
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let maze = GameScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(maze, transition: trans)
        } else if (name == "button6" || name == "label6") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            len = 6
            wid = 6
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let maze = GameScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(maze, transition: trans)
        } else if (name == "button7" || name == "label7") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            len = 7
            wid = 7
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let maze = GameScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(maze, transition: trans)
        } else if (name == "grandButton" || name == "grandLabel") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            len = 10
            wid = 10
            /*let trans = SKTransition.crossFade(withDuration: 0.5)
            let maze = GameScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(maze, transition: trans)*/
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let maze = Finale(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(maze, transition: trans)
        }
    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    public func touchUp(atPoint pos : CGPoint) {
        
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
