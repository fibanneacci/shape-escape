import Foundation
import PlaygroundSupport
import SpriteKit

var redPencil: SKSpriteNode = SKSpriteNode(imageNamed: "redPencil.png")
var yellowPencil: SKSpriteNode = SKSpriteNode(imageNamed: "yellowPencil.png")
var greenPencil: SKSpriteNode = SKSpriteNode(imageNamed: "greenPencil.png")
var grayPencil: SKSpriteNode = SKSpriteNode(imageNamed: "grayPencil.png")
var trianglePencil: SKSpriteNode = SKSpriteNode(imageNamed: "trianglePencil.png")
var planePencil: SKSpriteNode = SKSpriteNode(imageNamed: "planePencil.png")
var pencilNum: Int = -1

public class GameScene: SKScene {
    
    // Create grid which shows up on screen
    public func grid(r: Int, c: Int) { //generalize from 5x5 to all sizes
        let unitSize = CGSize(width: 400 / c, height: 400 / r)
        var xBuffer: CGFloat
        var yBuffer: CGFloat
        switch (len) {
        case 5:
            xBuffer = 80
            yBuffer = 200
            break
        case 6:
            xBuffer = 75
            yBuffer = 194
            break
        case 7:
            xBuffer = 70
            yBuffer = 188
            break
        default:
            xBuffer = 65
            yBuffer = 182
            break
        }
        for row in 0...r - 1 {
            for col in 0...c - 1 {
                let unit = SKShapeNode(rectOf: unitSize, cornerRadius: 0.125 * unitSize.width)
                //let unit = SKSpriteNode(color: SKColor.lightGray, size: unitSize)
                unit.name = "\(col)\(r - row - 1)"
                //unit.fillColor = SKColor.lightGray
                unit.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                unit.position = CGPoint(x: (CGFloat(col) * unitSize.width) + xBuffer, y: (CGFloat(row) * unitSize.height) + yBuffer)
                self.addChild(unit)
            }
        }
        // Add "players", a triangle shape and a circle shape
        // The objective is to get the triangle to the circle
        let trianglePlayer = SKSpriteNode(imageNamed: "triangle.png")
        trianglePlayer.name = "trianglePlayer"
        var scaleBy: CGFloat
        switch (len) {
        case 5:
            scaleBy = 0.5
            break
        case 6:
            scaleBy = 0.45
            break
        case 7:
            scaleBy = 0.4
            break
        default:
            scaleBy = 0.35
            break
        }
        trianglePlayer.setScale(scaleBy)
        trianglePlayer.position = gridUnitWithName(name: "00")!.position
        let circlePlayer = SKSpriteNode(imageNamed: "circle.png")
        circlePlayer.name = "circlePlayer"
        circlePlayer.setScale(scaleBy)
        circlePlayer.position = gridUnitWithName(name: "\(len - 1)\(wid - 1)")!.position
        self.addChild(circlePlayer)
        self.addChild(trianglePlayer)
    }
    
    // Return node with certain string name ("node" refers to a square on the grid)
    public func gridUnitWithName(name: String) -> SKShapeNode? {
        let gridUnit: SKShapeNode? = self.childNode(withName: name) as! SKShapeNode?
        return gridUnit
    }
    
    // Create random maze arrangement, by creating 2D-array with random values
    // and running Dijkstra's algorithm on it to find the shortest path from
    // the top left (source) to the bottom right (destination), then randomly
    // filling in the rest of the grid with obstacles
    public func generatePath(r: Int, c: Int) {
        // Create 2D-array with random integer values
        var arr = [[Int]](repeating: [Int](repeating: 0, count: c), count: r)
        for i in 0...r - 1 {
            for j in 0...c - 1 {
                arr[i][j] = Int.random(in: 0...100)
            }
        }
        arr[0][0] = 0
        // 2D distance array stores distance from source node (top left) to every other node
        var distance = [[Int]](repeating: [Int](repeating: 2147000000, count: c), count: r)
        // 2D parent array stores coordinates of parent of any given node
        let init_parent = ii()
        var parent = [[ii]](repeating: [ii](repeating: init_parent, count: c), count: r)
        // 2D path array shows whether or not any given node is part of shortest path
        var path = [[Bool]](repeating: [Bool](repeating: false, count: c), count: r)
        path[0][0] = true
        
        // Dijkstra's algorithm to find shortest path
        var dx = [0, -1, 0, 1]
        var dy = [-1, 0, 1, 0]
        // Priority queue implemented using array; continually sorted so that
        // unvisited node with shortest distance is first element
        var pq: [iii] = []
        var temp = iii()
        temp.dist = arr[0][0]
        temp.rowNum = 0
        temp.colNum = 0
        pq.append(temp)
        distance[0][0] = 0
        while (pq.count != 0) {
            // Get unvisited node with shortest distance from source
            let u: iii = pq[0]
            // Remove visited nodes from array
            pq.remove(at: 0)
            // If destination has been reached, end Dijkstra's algorithm
            if (u.rowNum == r && u.colNum == c) {
                break
            }
            // If distance to this node is greater than a distance previously stored, skip
            if (u.dist > distance[u.rowNum][u.colNum]) {
                continue
            }
            for i in 0...3 {
                var next = iii()
                // Check the adjacent nodes to current node in four cardinal directions
                next.rowNum = u.rowNum + dx[i]
                next.colNum = u.colNum + dy[i]
                // If a given adjacent node is out of bounds, skip
                if (next.rowNum < 0 || next.rowNum >= r || next.colNum < 0 || next.colNum >= c) {
                    continue
                }
                // Checks if any previously stored distance can be improved
                if (distance[u.rowNum][u.colNum] + arr[next.rowNum][next.colNum] < distance[next.rowNum][next.colNum]) {
                    // Store new, improved distance
                    distance[next.rowNum][next.colNum] = distance[u.rowNum][u.colNum] + arr[next.rowNum][next.colNum]
                    next.dist = distance[next.rowNum][next.colNum]
                    pq.append(next)
                    // Since array is being used to implement priority queue, have to sort again each time new element is appended
                    pq.sort(by: { $0.dist < $1.dist })
                    // Set parent of node being entered into priority queue as current node
                    var new_parent = ii()
                    new_parent.rowNum = u.rowNum
                    new_parent.colNum = u.colNum
                    parent[next.rowNum][next.colNum] = new_parent
                }
            }
        }
        
        // Using path defined by 2D parent array, mark nodes that are
        // part of the shortest path found using Dijkstra's as 'true'
        var curX: Int = r - 1
        var curY: Int = c - 1
        while (true) {
            if (curX == 0 && curY == 0) {
                break
            }
            path[curX][curY] = true
            let nextX: Int = parent[curX][curY].rowNum
            let nextY: Int = parent[curX][curY].colNum
            curX = nextX
            curY = nextY
        }
        
        // Traverse the 2D path array, and if a node is NOT part of
        // the shortest path, randomly determine whether or not it
        // will be an "obstacle" node
        // Weighted 55-45 in favor of "obstacle" rather than "no obstacle",
        // because using anything less (e.g. 50-50) generally made the mazes
        // too sparsely occupied
        for i in 0...r - 1 {
            for j in 0...c - 1 {
                if (!path[i][j]) {
                    let obstacle = Int.random(in: 1...20)
                    if (obstacle <= 11) {
                        gridUnitWithName(name: "\(i)\(j)")!.fillColor = SKColor.black
                    }
                }
            }
        }
    }
    
    public func clearColors() {
        for i in 0...len - 1 {
            for j in 0...wid - 1 {
                if (!(gridUnitWithName(name: "\(i)\(j)")!.fillColor.redComponent == 0 && gridUnitWithName(name: "\(i)\(j)")!.fillColor.blueComponent == 0 && gridUnitWithName(name: "\(i)\(j)")!.fillColor.greenComponent == 0 && gridUnitWithName(name: "\(i)\(j)")!.fillColor.alphaComponent == 1)) {
                    gridUnitWithName(name: "\(i)\(j)")!.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                }
            }
        }
        gridUnitWithName(name: "00")!.fillColor = SKColor.green
    }
    
    public func newBoard() {
        grid(r: len, c: wid)
        gridUnitWithName(name: "00")!.fillColor = SKColor.green
        // Create random boolean, "reachable", to determine if maze generated
        // will allow triangle to reach circle. If true, then circle is guaranteed
        // to be reachable. If false, then circle is NOT guaranteed to be reachable
        // (could be either reachable or unreachable)
        var reachable: Bool = Bool.random()
        if (len == 10 && wid == 10) {
            reachable = true
        }
        //print("reachable?")
        //print(reachable)
        if (reachable) {
            generatePath(r: len, c: wid)
        } else {
            for i in 0...len - 1 {
                for j in 0...wid - 1 {
                    let obstacle = Bool.random()
                    //print(obstacle)
                    if (obstacle) {
                        gridUnitWithName(name: "\(i)\(j)")!.fillColor = SKColor.black
                    }
                }
            }
            gridUnitWithName(name: "00")!.fillColor = SKColor.green
            gridUnitWithName(name: "\(len - 1)\(wid - 1)")!.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        }
        for i in 0..<len {
            for j in 0..<wid {
                //print(gridUnitWithName(name: "\(i)\(j)")!.fillColor)
                connectivity[i][j] = false
            }
        }
        connected(x: 0, y: 0)
        /*for i in 0..<len {
            for j in 0..<wid {
                print(gridUnitWithName(name: "\(i)\(j)")!.fillColor)
            }
        }*/
    }
    
    let insLabel = SKLabelNode(fontNamed: "San Francisco")
    
    public override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.setScale(1.5)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(background)
        
        let label1 = SKLabelNode(fontNamed: "San Francisco")
        label1.fontSize = 14
        label1.fontColor = SKColor.black
        label1.position = CGPoint(x: self.frame.midX, y: 610)
        label1.text = "Can you escape the maze and reach your friend?"
        let label1line2 = SKLabelNode(fontNamed: "San Francisco")
        label1line2.fontSize = 14
        label1line2.fontColor = SKColor.black
        label1line2.position = CGPoint(x: self.frame.midX, y: 595)
        label1line2.text = "To see the answer, select the \"triangle\" pencil and click"
        let label1line3 = SKLabelNode(fontNamed: "San Francisco")
        label1line3.fontSize = 14
        label1line3.fontColor = SKColor.black
        label1line3.position = CGPoint(x: self.frame.midX, y: 580)
        label1line3.text = "the destination node. But first, try to find out yourself!"
        insLabel.fontSize = 14
        insLabel.position = CGPoint(x: self.frame.midX, y: 565)
        
        let label2 = SKLabelNode(fontNamed: "San Francisco")
        label2.fontSize = 14
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: self.frame.midX, y: 130)
        label2.text = "Use these tools to help. Select one, then click or drag on the maze."
        
        redPencil.setScale(0.5)
        redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
        redPencil.name = "redPencil"
        yellowPencil.setScale(0.5)
        yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
        yellowPencil.name = "yellowPencil"
        greenPencil.setScale(0.5)
        greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
        greenPencil.name = "greenPencil"
        grayPencil.setScale(0.5)
        grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
        grayPencil.name = "grayPencil"
        trianglePencil.setScale(0.5)
        trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
        trianglePencil.name = "trianglePencil"
        pencilNum = -1
        
        addChild(label1)
        addChild(label1line2)
        addChild(label1line3)
        addChild(insLabel)
        addChild(label2)
        addChild(redPencil)
        addChild(yellowPencil)
        addChild(greenPencil)
        addChild(grayPencil)
        addChild(trianglePencil)
        
        let backButton = SKShapeNode(rectOf: CGSize(width: 50, height: 30), cornerRadius: 8)
        backButton.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        backButton.position = CGPoint(x: 36, y: 25)
        backButton.name = "backButton"
        let backLabel = SKLabelNode(fontNamed: "San Francisco")
        backLabel.fontColor = SKColor.white
        backLabel.text = "< back"
        backLabel.fontSize = 14
        backLabel.position = CGPoint(x: 36, y: 20)
        backLabel.name = "backLabel"
        addChild(backButton)
        addChild(backLabel)
        
        let clearButton = SKShapeNode(rectOf: CGSize(width: 75, height: 30), cornerRadius: 8)
        clearButton.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        clearButton.position = CGPoint(x: 48, y: 60)
        clearButton.name = "clearButton"
        let clearLabel = SKLabelNode(fontNamed: "San Francisco")
        clearLabel.fontColor = SKColor.white
        clearLabel.text = "clear colors"
        clearLabel.fontSize = 14
        clearLabel.position = CGPoint(x: 48, y: 55)
        clearLabel.name = "clearLabel"
        addChild(clearButton)
        addChild(clearLabel)
        
        let newButton = SKShapeNode(rectOf: CGSize(width: 75, height: 30), cornerRadius: 8)
        newButton.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        newButton.position = CGPoint(x: 48, y: 95)
        newButton.name = "newButton"
        let newLabel = SKLabelNode(fontNamed: "San Francisco")
        newLabel.fontColor = SKColor.white
        newLabel.text = "new board"
        newLabel.fontSize = 14
        newLabel.position = CGPoint(x: 48, y: 90)
        newLabel.name = "newLabel"
        addChild(newButton)
        addChild(newLabel)
        
        newBoard()
    }
    
    var connectivity = [[Bool]](repeating: [Bool](repeating: false, count: wid), count: len)
    var dx = [0, -1, 0, 1]
    var dy = [-1, 0, 1, 0]
    
    public func connected(x: Int, y: Int) {
        connectivity[x][y] = true
        for i in 0...3 {
            let nx: Int = x + dx[i]
            let ny: Int = y + dy[i]
            if (nx < 0 || nx >= len || ny < 0 || ny >= wid) {
                continue
            }
            if (gridUnitWithName(name: "\(nx)\(ny)")!.fillColor == NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) && !connectivity[nx][ny]) {
                connected(x: nx, y: ny)
            }
        }
    }
    
    public func touchDown(atPoint pos : CGPoint) {
        let node = atPoint(pos)
        var name = node.name
        if (name == nil) {
            return
        }
        if (name == "backButton" || name == "backLabel") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            let dir = SKTransitionDirection(rawValue: 2)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let menu = Menu(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(menu, transition: trans)
        } else if (name == "clearButton" || name == "clearLabel") {
            clearColors()
            return
        } else if (name == "newButton" || name == "newLabel") {
            for i in 0...len - 1 {
                for j in 0...wid - 1 {
                    gridUnitWithName(name: "\(i)\(j)")!.removeFromParent()
                }
            }
            childNode(withName: "trianglePlayer")?.removeFromParent()
            childNode(withName: "circlePlayer")?.removeFromParent()
            insLabel.text = ""
            newBoard()
            return
        } else if (name == "redPencil") {
            if (pencilNum == 0) {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = -1
            } else {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 60)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = 0
            }
        } else if (name == "yellowPencil") {
            if (pencilNum == 1) {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = -1
            } else {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 60)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = 1
            }
        } else if (name == "greenPencil") {
            if (pencilNum == 2) {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = -1
            } else {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 60)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = 2
            }
        } else if (name == "grayPencil") {
            if (pencilNum == 3) {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = -1
            } else {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 60)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = 3
            }
        } else if (name == "trianglePencil") {
            if (pencilNum == 4) {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 0)
                pencilNum = -1
            } else {
                redPencil.position = CGPoint(x: self.frame.midX - 96.0, y: 0)
                yellowPencil.position = CGPoint(x: self.frame.midX - 48.0, y: 0)
                greenPencil.position = CGPoint(x: self.frame.midX, y: 0)
                grayPencil.position = CGPoint(x: self.frame.midX + 48.0, y: 0)
                trianglePencil.position = CGPoint(x: self.frame.midX + 96.0, y: 60)
                pencilNum = 4
            }
        } else if (name == "trianglePlayer") { // If triangle was clicked, signifies that current node was clicked
            //name = "\(current.rowNum)\(current.colNum)"
            return
        } else {
            if (name == "circlePlayer") { // If circle was clicked, signifies that bottom right node was clicked
                name = "\(len - 1)\(wid - 1)"
            }
            if (!(gridUnitWithName(name: name!)!.fillColor.redComponent == 0 && gridUnitWithName(name: name!)!.fillColor.blueComponent == 0 && gridUnitWithName(name: name!)!.fillColor.greenComponent == 0 && gridUnitWithName(name: name!)!.fillColor.alphaComponent == 1) && name != "00") { //color comparisons?
                var current = ii()
                let substr1 = name!.prefix(1)
                let str1 = String(substr1)
                current.rowNum = Int(str1)!
                let substr2 = name!.suffix(1)
                let str2 = String(substr2)
                current.colNum = Int(str2)!
                switch (pencilNum) {
                case 0:
                    gridUnitWithName(name: name!)!.fillColor = SKColor.red
                    break
                case 1:
                    gridUnitWithName(name: name!)!.fillColor = SKColor.yellow
                    break
                case 2:
                    gridUnitWithName(name: name!)!.fillColor = SKColor.green
                    break
                case 3:
                    gridUnitWithName(name: name!)!.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                    break
                case 4:
                    if (current.rowNum == len - 1 && current.colNum == wid - 1) {
                        if (connectivity[current.rowNum][current.colNum]) {
                            let action = SKAction.playSoundFileNamed("congrats.m4a", waitForCompletion: false)
                            self.run(action)
                            insLabel.fontColor = SKColor.green
                            insLabel.text = "Congratulations, you made it!"
                            childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                        } else {
                            let action = SKAction.playSoundFileNamed("fail.m4a", waitForCompletion: false)
                            self.run(action)
                            insLabel.fontColor = SKColor.red
                            insLabel.text = "Uh-oh, looks like there's no escape!"
                        }
                        return
                    }
                    if (connectivity[current.rowNum][current.colNum]) {
                        insLabel.fontColor = SKColor.blue
                        insLabel.text = "Will you make it?"
                        childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                    } else {
                        insLabel.fontColor = SKColor.red
                        insLabel.text = "Uh-oh, that node is not reachable from the source node."
                    }
                    break
                default: break
                }
            } else {
                return
            }
        }
    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        let node = atPoint(pos)
        var name = node.name
        if (name == nil) {
            return
        } else if (name == "circlePlayer") { // If circle was clicked, signifies that bottom right node was clicked
            name = "\(len - 1)\(wid - 1)"
        } else if (name!.count != 2) {
            return
        }
        if (!(gridUnitWithName(name: name!)!.fillColor.redComponent == 0 && gridUnitWithName(name: name!)!.fillColor.blueComponent == 0 && gridUnitWithName(name: name!)!.fillColor.greenComponent == 0 && gridUnitWithName(name: name!)!.fillColor.alphaComponent == 1) && name != "00") { //color comparisons?
            var current = ii()
            let substr1 = name!.prefix(1)
            let str1 = String(substr1)
            current.rowNum = Int(str1)!
            let substr2 = name!.suffix(1)
            let str2 = String(substr2)
            current.colNum = Int(str2)!
            switch (pencilNum) {
            case 0:
                gridUnitWithName(name: name!)!.fillColor = SKColor.red
                break
            case 1:
                gridUnitWithName(name: name!)!.fillColor = SKColor.yellow
                break
            case 2:
                gridUnitWithName(name: name!)!.fillColor = SKColor.green
                break
            case 3:
                gridUnitWithName(name: name!)!.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                break
            case 4:
                if (current.rowNum == len - 1 && current.colNum == wid - 1) {
                    if (connectivity[current.rowNum][current.colNum]) {
                        let action = SKAction.playSoundFileNamed("congrats.m4a", waitForCompletion: false)
                        self.run(action)
                        insLabel.fontColor = SKColor.green
                        insLabel.text = "Congratulations, you made it!"
                        childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                    } else {
                        let action = SKAction.playSoundFileNamed("fail.m4a", waitForCompletion: false)
                        self.run(action)
                        insLabel.fontColor = SKColor.red
                        insLabel.text = "Uh-oh, looks like there's no escape!"
                    }
                    return
                }
                if (connectivity[current.rowNum][current.colNum]) {
                    insLabel.fontColor = SKColor.blue
                    insLabel.text = "Will you make it?"
                    childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                } else {
                    insLabel.fontColor = SKColor.red
                    insLabel.text = "Uh-oh, that node is not reachable from the source node."
                }
                break
            default: break
            }
        } else if (name == "00") {
            var current = ii()
            let substr1 = name!.prefix(1)
            let str1 = String(substr1)
            current.rowNum = Int(str1)!
            let substr2 = name!.suffix(1)
            let str2 = String(substr2)
            current.colNum = Int(str2)!
            if (pencilNum == 4) {
                if (current.rowNum == len - 1 && current.colNum == wid - 1) {
                    if (connectivity[current.rowNum][current.colNum]) {
                        let action = SKAction.playSoundFileNamed("congrats.m4a", waitForCompletion: false)
                        self.run(action)
                        insLabel.fontColor = SKColor.green
                        insLabel.text = "Congratulations, you made it!"
                        childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                    } else {
                        let action = SKAction.playSoundFileNamed("fail.m4a", waitForCompletion: false)
                        self.run(action)
                        insLabel.fontColor = SKColor.red
                        insLabel.text = "Uh-oh, looks like there's no escape!"
                    }
                    return
                }
                if (connectivity[current.rowNum][current.colNum]) {
                    insLabel.fontColor = SKColor.blue
                    insLabel.text = "Will you make it?"
                    childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                } else {
                    insLabel.fontColor = SKColor.red
                    insLabel.text = "Uh-oh, that node is not reachable from the source node."
                }
            }
        } else {
            return
        }
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
