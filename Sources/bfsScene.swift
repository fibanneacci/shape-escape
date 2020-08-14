import Foundation
import PlaygroundSupport
import SpriteKit

public class bfsScene: SKScene {
    
    let instructionLabel = SKLabelNode(fontNamed: "San Francisco")
    
    public override func didMove(to view: SKView) {
        // Set up background and information labels
        let background = SKSpriteNode(imageNamed: "background.png")
        background.name = "background"
        background.setScale(1.5)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(background)
        
        let label1 = SKLabelNode(fontNamed: "San Francisco")
        label1.fontSize = 18
        label1.fontColor = SKColor.black
        label1.position = CGPoint(x: self.frame.midX, y: 610)
        label1.text = "Let's start with BFS!"
        let label2 = SKLabelNode(fontNamed: "San Francisco")
        label2.fontSize = 18
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: self.frame.midX, y: 585)
        label2.text = "BFS (breadth-first search) visits paths \"level-by-level\"." //improve expl
        
        let string3: NSString = "We will use red to mark squares we'll \"visit\" later,"
        let mutableString3 = NSMutableAttributedString(string: string3 as String)
        mutableString3.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.red, range: NSRange(location: 12, length: 3))
        let string4: NSString = "yellow to mark squares in the level we're currently \"visiting\","
        let mutableString4 = NSMutableAttributedString(string: string4 as String)
        mutableString4.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.systemYellow, range: NSRange(location: 0, length: 6))
        let string5: NSString = "and green to mark squares we've \"visited\"."
        let mutableString5 = NSMutableAttributedString(string: string5 as String)
        mutableString5.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.systemGreen, range: NSRange(location: 4, length: 5))
        let string6: NSString = "Don't walk on the black squares!"
        let mutableString6 = NSMutableAttributedString(string: string6 as String)
        
        let label3 = SKLabelNode(fontNamed: "San Francisco")
        label3.attributedText = mutableString3
        label3.position = CGPoint(x: self.frame.midX, y: 560)
        let label4 = SKLabelNode(fontNamed: "San Francisco")
        label4.attributedText = mutableString4
        label4.position = CGPoint(x: self.frame.midX, y: 545)
        let label5 = SKLabelNode(fontNamed: "San Francisco")
        label5.attributedText = mutableString5
        label5.position = CGPoint(x: self.frame.midX, y: 530)
        let label6 = SKLabelNode(fontNamed: "San Francisco")
        label6.attributedText = mutableString6
        label6.position = CGPoint(x: self.frame.midX, y: 515)
        let label7 = SKLabelNode(fontNamed: "San Francisco")
        label7.text = "Can you (the triangle) reach your friend (the circle)?"
        label7.fontSize = 18
        label7.fontColor = SKColor.black
        label7.position = CGPoint(x: self.frame.midX, y: 490)
        instructionLabel.text = instructions[0]
        instructionLabel.fontSize = 18
        instructionLabel.fontColor = SKColor.blue
        instructionLabel.position = CGPoint(x: self.frame.midX, y: 460)
        addChild(label1)
        addChild(label2)
        addChild(label3)
        addChild(label4)
        addChild(label5)
        addChild(label6)
        addChild(label7)
        addChild(instructionLabel)
        bfsSequence(r: 5, c: 5)
        
        let pageLabel = SKLabelNode(fontNamed: "San Francisco")
        pageLabel.fontSize = 14
        pageLabel.fontColor = SKColor.black
        pageLabel.position = CGPoint(x: self.frame.midX, y: 15)
        pageLabel.text = "Page 1 of 2 in this tutorial."
        addChild(pageLabel)
        
        let backButton = SKShapeNode(rectOf: CGSize(width: 50, height: 24), cornerRadius: 6)
        backButton.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        backButton.position = CGPoint(x: self.frame.midX / 2 + 5, y: 20)
        backButton.name = "backButton"
        let backLabel = SKLabelNode(fontNamed: "San Francisco")
        backLabel.fontColor = SKColor.white
        backLabel.text = "< back"
        backLabel.fontSize = 14
        backLabel.position = CGPoint(x: self.frame.midX / 2 + 5, y: 15)
        backLabel.name = "backLabel"
        addChild(backButton)
        addChild(backLabel)
        let nextButton = SKShapeNode(rectOf: CGSize(width: 50, height: 24), cornerRadius: 6)
        nextButton.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        nextButton.position = CGPoint(x: self.frame.midX * 1.5 - 5, y: 20)
        nextButton.name = "nextButton"
        let nextLabel = SKLabelNode(fontNamed: "San Francisco")
        nextLabel.fontColor = SKColor.white
        nextLabel.text = "next >"
        nextLabel.fontSize = 14
        nextLabel.position = CGPoint(x: self.frame.midX * 1.5 - 5, y: 15)
        nextLabel.name = "nextLabel"
        addChild(nextButton)
        addChild(nextLabel)
    }
    
    // Create grid which shows up on screen
    public func grid(r: Int, c: Int) { //generalize from 5x5 to all sizes
        let unitSize = CGSize(width: 400 / c, height: 400 / r)
        let buffer: CGFloat = 80
        for row in 0...r - 1 {
            for col in 0...c - 1 {
                let unit = SKShapeNode(rectOf: unitSize, cornerRadius: 0.125 * unitSize.width)
                //let unit = SKSpriteNode(color: SKColor.lightGray, size: unitSize)
                unit.name = "\(col)\(r - row - 1)"
                //unit.fillColor = SKColor.lightGray
                unit.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                unit.position = CGPoint(x: (CGFloat(col) * unitSize.width) + buffer, y: (CGFloat(row) * unitSize.height) + buffer)
                self.addChild(unit)
            }
        }
        // Add "players", a triangle shape and a circle shape
        // The objective is to get the triangle to the circle
        let trianglePlayer = SKSpriteNode(imageNamed: "triangle.png")
        trianglePlayer.name = "trianglePlayer"
        trianglePlayer.setScale(0.5)
        trianglePlayer.position = gridUnitWithName(name: "00")!.position
        let circlePlayer = SKSpriteNode(imageNamed: "circle.png")
        circlePlayer.name = "circlePlayer"
        circlePlayer.setScale(0.5)
        circlePlayer.position = gridUnitWithName(name: "\(r - 1)\(c - 1)")!.position
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
    
    var toggle: Bool = false
    var current = ii()
    var gridSize = ii()
    /*var rows: Int
    var cols: Int*/
    let instructions = ["Click the square you would like to visit next!", "Click the square(s) you can reach from this square."] //add flash effects to make clearer
    var dx = [0, -1, 0, 1]
    var dy = [-1, 0, 1, 0]
    
    public func reachedEnd() {
        instructionLabel.fontColor = SKColor.green
        instructionLabel.text = "Congratulations, you made it!"
        let action = SKAction.playSoundFileNamed("congrats.m4a", waitForCompletion: false)
        self.run(action)
        /*let pause = SKAction.wait(forDuration: 1.5)
        self.run(pause, completion: {
            let trans = SKTransition.crossFade(withDuration: 0.5)
            let dfs = dfsScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(dfs, transition: trans) //unwrap?
        })*/
    }
    
    public func process(r: Int, c: Int) {
        if (!toggle) { // Currently picking node to visit next
            //print("debug process picking visit")
            // Set instructions label to tell user to click a new square to visit
            instructionLabel.text = instructions[0]
            // If user is currently on ending square, end process
            if (current.rowNum == r - 1 && current.colNum == c - 1) {
                reachedEnd()
                return
            }
            // Check adjacent squares of current square and highlight them yellow
            for i in 0...3 {
                let nx = current.rowNum + dx[i]
                let ny = current.colNum + dy[i]
                if (nx < 0 || nx >= r || ny < 0 || ny >= c) {
                    continue
                }
                if (gridUnitWithName(name: "\(nx)\(ny)")!.fillColor == NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)) {
                    gridUnitWithName(name: "\(nx)\(ny)")!.fillColor = SKColor.yellow
                }
            }
        } else { // Currently marking "see"-able nodes
            //print("debug process picking red")
            // Update instructions label to tell user to mark the squares
            // they can "see" from their current square
            instructionLabel.text = instructions[1]
            var temp_adj = ii()
            var completed: Int = 0
            // Checks if all possible "see"-able squares have been selected
            // by incrementing "complete" counter only if an adjacent square
            // is either black (impassable) or any color other than gray
            for i in 0...3 {
                temp_adj.rowNum = current.rowNum + dx[i]
                temp_adj.colNum = current.colNum + dy[i]
                if (temp_adj.rowNum < 0 || temp_adj.rowNum >= r || temp_adj.colNum < 0 || temp_adj.colNum >= c) {
                    completed += 1
                    continue
                }
                if (gridUnitWithName(name: "\(temp_adj.rowNum)\(temp_adj.colNum)")!.fillColor == SKColor.black) {
                    completed += 1
                } else if (gridUnitWithName(name: "\(temp_adj.rowNum)\(temp_adj.colNum)")!.fillColor != NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)) {
                    completed += 1
                }
            }
            // If all possible "see"-able squares have been selected,
            // check if any yellow square (squares in current "level")
            // remain unvisited
            if (completed == 4) {
                //print("completed reds")
                var yellowCounter: Int = 0
                for i in 0...gridSize.rowNum - 1 {
                    for j in 0...gridSize.colNum - 1 {
                        if (gridUnitWithName(name: "\(i)\(j)")!.fillColor == SKColor.yellow) {
                            yellowCounter += 1
                        }
                    }
                }
                let pause = SKAction.wait(forDuration: 0.2)
                self.run(pause, completion: {
                    // If no yellow squares remain, go through grid and mark all pink squares as yellow
                    // to signify a new level of breadth in the search
                    if (yellowCounter == 0) {
                        for i in 0...self.gridSize.rowNum - 1 {
                            for j in 0...self.gridSize.colNum - 1 {
                                //print("\(i)\(j): \(gridUnitWithName(name: "\(i)\(j)")!.fillColor)")
                                //if (gridUnitWithName(name: "\(i)\(j)")!.fillColor == SKColor.systemPink) {
                                if (self.gridUnitWithName(name: "\(i)\(j)")!.fillColor == SKColor.red) {
                                    self.gridUnitWithName(name: "\(i)\(j)")!.fillColor = SKColor.yellow
                                }
                            }
                        }
                    }
                })
                // Flip toggle again to signify that we are now picking new nodes to visit
                self.toggle = !self.toggle
                self.process(r: self.gridSize.rowNum, c: self.gridSize.colNum)
            }
        }
    }
    
    public func touchDown(atPoint pos : CGPoint) {
        // Get name of the node located at mouse click
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
            let splash = Splash(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(splash, transition: trans)
        }
        if (name == "nextButton" || name == "nextLabel") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let dfs = dfsScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(dfs, transition: trans)
        }
        if (name == "trianglePlayer") { // If triangle was clicked, signifies that current node was clicked
            name = "\(current.rowNum)\(current.colNum)"
        } else if (name == "circlePlayer") { // If circle was clicked, signifies that bottom right node was clicked
            name = "\(gridSize.rowNum - 1)\(gridSize.colNum - 1)"
        } else if (name!.count != 2) {
            return
        }
        if (!toggle) { // If current step involves picking next node to visit
            //print("debug touchDown picking visit")
            // Mark node chosen by user as visited (green) if node is yellow
            if (gridUnitWithName(name: name!)!.fillColor == SKColor.yellow) {
                gridUnitWithName(name: name!)!.fillColor = SKColor.green
                // Update user's current node to the newly-selected one
                let substr1 = name!.prefix(1)
                let str1 = String(substr1)
                current.rowNum = Int(str1)!
                let substr2 = name!.suffix(1)
                let str2 = String(substr2)
                current.colNum = Int(str2)!
                childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                if (!(current.rowNum == gridSize.rowNum - 1 && current.colNum == gridSize.colNum - 1)) {
                    toggle = !toggle
                }
                // Process step involving marking "see"-able nodes
                process(r: gridSize.rowNum, c: gridSize.colNum)
            }
        } else { // If the current step involves the step for picking "see"-able nodes (marking them pink)
            //print("debug touchDown picking red")
            var temp_adj = ii()
            var adj: [ii] = []
            // Create an array of all possible "see"-able nodes (any gray adjacent nodes)
            for i in 0...3 {
                temp_adj.rowNum = current.rowNum + dx[i]
                temp_adj.colNum = current.colNum + dy[i]
                if (temp_adj.rowNum < 0 || temp_adj.rowNum >= gridSize.rowNum || temp_adj.colNum < 0 || temp_adj.colNum >= gridSize.colNum) {
                    continue
                }
                if (gridUnitWithName(name: "\(temp_adj.rowNum)\(temp_adj.colNum)")!.fillColor == NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)) {
                    adj.append(temp_adj)
                }
            }
            // If the user clicked a gray node, check if the node is one of possible nodes
            // determined above. If so, color it pink
            if (gridUnitWithName(name: name!)!.fillColor == NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)) {
                let substr1 = name!.prefix(1)
                let str1 = String(substr1)
                temp_adj.rowNum = Int(str1)!
                let substr2 = name!.suffix(1)
                let str2 = String(substr2)
                temp_adj.colNum = Int(str2)!
                for i in 0...adj.count - 1 {
                    if (temp_adj.rowNum == adj[i].rowNum && temp_adj.colNum == adj[i].colNum) {
                        //gridUnitWithName(name: name!)!.fillColor = SKColor.systemPink
                        gridUnitWithName(name: name!)!.fillColor = SKColor.red
                    }
                }
            }
            // Process current situation, still under the same step
            process(r: gridSize.rowNum, c: gridSize.colNum)
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    
    public func bfsSequence(r: Int, c: Int) {
        gridSize.rowNum = r
        gridSize.colNum = c
        
        grid(r: r, c: c)
        gridUnitWithName(name: "00")!.fillColor = SKColor.green
        generatePath(r: r, c: c)
        
        current.rowNum = 0
        current.colNum = 0
        
        let pause = SKAction.wait(forDuration: 0.0)
        self.run(pause, completion: {
            self.process(r: r, c: c)
            })
        //process(r: r, c: c)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
