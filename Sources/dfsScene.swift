import Foundation
import PlaygroundSupport
import SpriteKit

public class dfsScene: SKScene {
    
    let instructionLabel = SKLabelNode(fontNamed: "San Francisco")
    
    public override func didMove(to view: SKView) {
        // Set up background and information labels
        let background = SKSpriteNode(imageNamed: "background.png")
        background.setScale(1.5)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(background)
        
        let label1 = SKLabelNode(fontNamed: "San Francisco")
        label1.fontSize = 18
        label1.fontColor = SKColor.black
        label1.position = CGPoint(x: self.frame.midX, y: 610)
        label1.text = "Next up is DFS."
        let label2 = SKLabelNode(fontNamed: "San Francisco")
        label2.fontSize = 18
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: self.frame.midX, y: 585)
        label2.text = "DFS (depth-first search) goes all the way down one path" //improve expl
        let label2line2 = SKLabelNode(fontNamed: "San Francisco")
        label2line2.fontSize = 18
        label2line2.fontColor = SKColor.black
        label2line2.position = CGPoint(x: self.frame.midX, y: 560)
        label2line2.text = "before starting down another, backtracking if stuck."
        
        /*let string3: NSString = "We will use red to mark squares we've \"seen\","
        let mutableString3 = NSMutableAttributedString(string: string3 as String)
        mutableString3.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.red, range: NSRange(location: 12, length: 3))*/
        let string4: NSString = "This time, we will use yellow to mark squares we can \"visit\","
        let mutableString4 = NSMutableAttributedString(string: string4 as String)
        mutableString4.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.systemYellow, range: NSRange(location: 23, length: 6))
        let string5: NSString = "and green to mark squares we've \"visited\"."
        let mutableString5 = NSMutableAttributedString(string: string5 as String)
        mutableString5.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.systemGreen, range: NSRange(location: 4, length: 5))
        /*let string6: NSString = "Don't walk on the black squares!"
        let mutableString6 = NSMutableAttributedString(string: string6 as String)*/
        
        /*let label3 = SKLabelNode(fontNamed: "San Francisco")
        label3.attributedText = mutableString3
        label3.position = CGPoint(x: self.frame.midX, y: 510)*/
        let label4 = SKLabelNode(fontNamed: "San Francisco")
        label4.attributedText = mutableString4
        label4.position = CGPoint(x: self.frame.midX, y: 535)
        let label5 = SKLabelNode(fontNamed: "San Francisco")
        label5.attributedText = mutableString5
        label5.position = CGPoint(x: self.frame.midX, y: 520)
        /*let label6 = SKLabelNode(fontNamed: "San Francisco")
        label6.attributedText = mutableString6
        label6.position = CGPoint(x: self.frame.midX, y: 465)*/
        let label6 = SKLabelNode(fontNamed: "San Francisco")
        label6.text = "Can you reach your friend this time?"
        label6.fontSize = 18
        label6.fontColor = SKColor.black
        label6.position = CGPoint(x: self.frame.midX, y: 495)
        instructionLabel.text = instructions[0]
        instructionLabel.fontSize = 18
        instructionLabel.fontColor = SKColor.blue
        instructionLabel.position = CGPoint(x: self.frame.midX, y: 465)
        addChild(label1)
        addChild(label2)
        addChild(label2line2)
        //addChild(label3)
        addChild(label4)
        addChild(label5)
        addChild(label6)
        addChild(instructionLabel)
        dfsSequence(r: 5, c: 5)
        
        let pageLabel = SKLabelNode(fontNamed: "San Francisco")
        pageLabel.fontSize = 14
        pageLabel.fontColor = SKColor.black
        pageLabel.position = CGPoint(x: self.frame.midX, y: 15)
        pageLabel.text = "Page 2 of 2 in this tutorial."
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
        // Weighted 65-35 in favor of "obstacle" rather than "no obstacle",
        // because using anything less (e.g. 50-50) generally made the mazes
        // too sparsely occupied
        for i in 0...r - 1 {
            for j in 0...c - 1 {
                if (!path[i][j]) {
                    let obstacle = Int.random(in: 1...20)
                    if (obstacle <= 13) {
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
    let instructions = ["Click the square you would like to visit next!", "Uh-oh, time to backtrack."] //add flash effects to make clearer
    var dx = [0, -1, 0, 1]
    var dy = [-1, 0, 1, 0]
    var pathArr: [ii] = []
    
    public func reachedEnd() {
        instructionLabel.fontColor = SKColor.green
        instructionLabel.text = "Congratulations, you made it!"
        let action = SKAction.playSoundFileNamed("congrats.m4a", waitForCompletion: false)
        self.run(action)
        /*let pause = SKAction.wait(forDuration: 1.5)
        self.run(pause, completion: {
            let trans = SKTransition.crossFade(withDuration: 0.5)
            let menu = Menu(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(menu, transition: trans) //unwrap?
        })*/
    }
    
    public func process(r: Int, c: Int) {
        if (!toggle) { // Currently picking node to visit next
            //print("debug process picking visit")
            // Set instructions label to tell user to click a new square to visit
            instructionLabel.text = instructions[0]
            instructionLabel.fontColor = SKColor.blue
            // If user is currently on ending square, end process
            if (current.rowNum == r - 1 && current.colNum == c - 1) {
                reachedEnd()
                return
            }
            var yellowCounter: Int = 0
            // Check adjacent squares of current square and highlight them yellow
            for i in 0...3 {
                let nx = current.rowNum + dx[i]
                let ny = current.colNum + dy[i]
                if (nx < 0 || nx >= r || ny < 0 || ny >= c) {
                    continue
                }
                // If there are adjacent squares that are gray, mark them as yellow
                if (gridUnitWithName(name: "\(nx)\(ny)")!.fillColor == NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)) {
                    gridUnitWithName(name: "\(nx)\(ny)")!.fillColor = SKColor.yellow
                    yellowCounter += 1
                }
            }
            // If there are no places to go, it's time to backtrack
            if (yellowCounter == 0) {
                toggle = !toggle
                process(r: r, c: c)
            }
        } else { // Currently backtracking
            //print("debug process backtracking")
            // Update instructions label to notification that
            // it's time to backtrack
            instructionLabel.text = instructions[1]
            instructionLabel.fontColor = SKColor.red
            let pause2 = SKAction.wait(forDuration: 0.5)
            self.run(pause2, completion: {
                var temp_adj = ii()
                var index: Int = self.pathArr.count - 1
                // Move backwards along the path until a node with visitable adjacent node(s) is found
                while (true) {
                    if (index < 0) {
                        break
                    }
                    //print(index)
                    temp_adj = self.pathArr[index]
                    self.pathArr.remove(at: index)
                    // Update current node to the one we've backtracked to
                    self.current.rowNum = temp_adj.rowNum
                    self.current.colNum = temp_adj.colNum
                    // Move triangle to show that it's backtracking
                    //let pause = SKAction.wait(forDuration: 0.5)
                    //self.run(pause, completion: {
                        self.childNode(withName: "trianglePlayer")!.position = self.gridUnitWithName(name: "\(self.current.rowNum)\(self.current.colNum)")!.position
                    //})
                    // Check all adjacent; if there are gray adjacent squares, that means
                    // the current node has visitable adjacent node(s)
                    var doneBacktracking: Bool = false
                    for i in 0...3 {
                        let nx = temp_adj.rowNum + self.dx[i]
                        let ny = temp_adj.colNum + self.dy[i]
                        if (nx < 0 || nx >= r || ny < 0 || ny >= c) {
                            continue
                        }
                        if (self.gridUnitWithName(name: "\(nx)\(ny)")!.fillColor == NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)) {
                            doneBacktracking = true
                            break
                        }
                    }
                    if (doneBacktracking) {
                        self.toggle = !self.toggle
                        self.process(r: r, c: c)
                        break
                    }
                    index -= 1
                }
            })
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
            let bfs = bfsScene(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(bfs, transition: trans)
        }
        if (name == "nextButton" || name == "nextLabel") {
            let action = SKAction.playSoundFileNamed("whoosh.m4a", waitForCompletion: false)
            self.run(action)
            let dir = SKTransitionDirection(rawValue: 3)
            let trans = SKTransition.push(with: dir!, duration: 0.2)
            let menu = Menu(size: CGSize(width: 480, height: 640))
            self.scene!.view!.presentScene(menu, transition: trans)
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
                // Add current node to array storing path, for purposes of backtracking later
                pathArr.append(current)
                // Unmark the other yellow adjacent squares
                var temp_adj = ii()
                for i in 0...3 {
                    temp_adj.rowNum = current.rowNum + dx[i]
                    temp_adj.colNum = current.colNum + dy[i]
                    if (temp_adj.rowNum < 0 || temp_adj.rowNum >= gridSize.rowNum || temp_adj.colNum < 0 || temp_adj.colNum >= gridSize.colNum) {
                        continue
                    }
                    if (gridUnitWithName(name: "\(temp_adj.rowNum)\(temp_adj.colNum)")!.fillColor == SKColor.yellow) {
                        gridUnitWithName(name: "\(temp_adj.rowNum)\(temp_adj.colNum)")!.fillColor = NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                    }
                }
                // Update user's current node to the newly-selected one
                let substr1 = name!.prefix(1)
                let str1 = String(substr1)
                current.rowNum = Int(str1)!
                let substr2 = name!.suffix(1)
                let str2 = String(substr2)
                current.colNum = Int(str2)!
                childNode(withName: "trianglePlayer")!.position = gridUnitWithName(name: name!)!.position
                /*// Add new node to array storing path, for purposes of backtracking later
                pathArr.append(current)*/
                //toggle = !toggle
                // Continue to process step involving visiting new nodes
                process(r: gridSize.rowNum, c: gridSize.colNum)
            }
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    
    public func dfsSequence(r: Int, c: Int) {
        gridSize.rowNum = r
        gridSize.colNum = c
        
        grid(r: r, c: c)
        gridUnitWithName(name: "00")!.fillColor = SKColor.green
        generatePath(r: r, c: c)
        
        current.rowNum = 0
        current.colNum = 0
        
        /*var source = ii()
        source.rowNum = 0
        source.colNum = 0
        pathArr.append(source)*/
        
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
