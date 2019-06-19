import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Герой
    var player:SKSpriteNode!
    
    //Для джойстика
    let joystick = Joystick()
    var isMoving:Bool!
    let deltaJoystick = SKLabelNode() //это костыль,мы не будем пользоваться UI как таковым, у нас все расположения интерфейса будут высчитываться с помощью координат героя + дельты константы
    
    //Камера
    let cam = SKCameraNode()
    
    //Элементы карты
    var fon:SKSpriteNode!
    
    //Анимация героя
    var playerWalkingDownFrames: [SKTexture] = []
    var playerWalkingLeftFrames: [SKTexture] = []
    var playerWalkingUpFrames: [SKTexture] = []
    var movingLeft = true
    var checkDirection:String! = "down"
    var lastDirection:String! = "down"
    
    //Init
    override func didMove(to view: SKView) {
        creatingPlayer()
        creatingJoystick()
        creatingFon()
        
        //Камера
        self.camera = cam
    
        //Физика
        self.physicsBody?.isDynamic = true
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
 
    func creatingPlayer() {
        playerWalkingDownFrames = buildFrames(atlasName: "walkingDown")
        playerWalkingLeftFrames = buildFrames(atlasName: "walkingLeft")
        playerWalkingUpFrames = buildFrames(atlasName: "walkingUp")
        
        let firstFrameTexture = playerWalkingDownFrames[0]
        player = SKSpriteNode(texture: firstFrameTexture)
        player.physicsBody =  SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.position = CGPoint.zero
        self.addChild(player)

    }
    
    func creatingJoystick(){
        joystick.position = CGPoint.zero //все равно какая, update изменит
        joystick.zPosition = 10
        self.addChild(joystick)
        isMoving = false
        
        deltaJoystick.text=""
        deltaJoystick.position = CGPoint(x: size.width/6-size.width/2, y:size.height/5-size.height/2)
        self.addChild(deltaJoystick)
    }
    
    func creatingFon(){
        fon = SKSpriteNode(imageNamed: "fon")
        fon.position = CGPoint.zero
        fon.zPosition = -10
        fon.setScale(1)
        self.addChild(fon)
    }
  
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Перемещение по джостику
        var flag:Bool!
        flag = true
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < player.position.x && location.y <  player.position.y - deltaJoystick.position.y {
                if isMoving{
                    flag = false
                    joystick.moveJoystick(touch: touches.first!)
                    joystick.joystickAction = {(x: CGFloat,y : CGFloat) in
                        var curVector = CGVector(dx: x, dy: y)
                        curVector = curVector.normalize()
                        let x:Float = Float(curVector.dx)
                        let y:Float = Float(curVector.dy)
                        self.lastDirection = self.checkDirection
                        //Каждое напраление эт угол образованный tg(Pi/4+Pi/2*k)
                        if x>0 && (x/y > 1 || x/y < -1){
                            self.checkDirection = "right"
                        }else if x/y > 1 || x/y < -1{
                            self.checkDirection = "left"
                        }else if y > 0 {
                            self.checkDirection = "up"
                        }else{
                            self.checkDirection = "down"
                        }
                        curVector *= 100
                        self.player.physicsBody?.velocity = curVector
                    }
                }
            }
        }
        if flag {
            isMoving = false
            joystick.stick.position = joystick.joystick.position
            player!.physicsBody!.isResting = true
             playerMoveEnded()
             checkDirection = ""
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Чек область под джостик
            if location.x <  player.position.x && location.y <  player.position.y - deltaJoystick.position.y {
                isMoving = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.x <  player.position.x && location.y <  player.position.y - deltaJoystick.position.y {
                // Возвращем джостик в исходное положение,герой остановка
                isMoving = false
                joystick.stick.position = joystick.joystick.position
                player!.physicsBody!.isResting = true
                playerMoveEnded()
                checkDirection = ""
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = player.position
        joystick.position.x = player.position.x + deltaJoystick.position.x
        joystick.position.y = player.position.y + deltaJoystick.position.y
    
        checkerDirection() //меняет анимацию ходьбы при смене направления
    }
    
    func checkerDirection(){
        switch checkDirection {
        case "up":
            if self.lastDirection != "up"{
                self.playerWalking(to:self.playerWalkingUpFrames)
            }
        case "right":
            if self.lastDirection != "right"{
                self.playerWalking(to:self.playerWalkingLeftFrames)
                if(self.movingLeft){
                    self.player.xScale = self.player.xScale * -1
                    self.movingLeft = false
                }
            }
        case "left":
            if self.lastDirection != "left"{
                if(!self.movingLeft){
                    self.player.xScale = self.player.xScale * -1
                    self.movingLeft = true
                }
                self.playerWalking(to:self.playerWalkingLeftFrames)
            }
        case "down":
            if self.lastDirection != "down"{
                self.playerWalking(to:self.playerWalkingDownFrames)
            }
        default:
            playerMoveEnded()
            checkDirection = ""
        }
    }
    
    
    //Создаем гифку
    func buildFrames(atlasName: String) -> [SKTexture] {
        let wAtlas = SKTextureAtlas(named: atlasName)
        var walkFrames: [SKTexture] = []
        let numImages = wAtlas.textureNames.count
        for i in 1...numImages {
            let texName = "\(atlasName)\(i)"
            walkFrames.append(wAtlas.textureNamed(texName))
        }
        return walkFrames
    }
    
    func playerWalking(to: [SKTexture]) {
        player.run(SKAction.repeatForever(
            SKAction.animate(with: to,
                             timePerFrame: 0.16,
                             resize: true,
                             restore: true)))
    }
    
    func playerMoveEnded() {
        player.removeAllActions()
    }
    
    
    
}


//Расширим класс CGVector некоторыми полезными функциями для перемещения
public extension CGVector {
    
    public func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    func normalized() -> CGVector {
        let len = length()
        return len>0 ? self / len : CGVector.zero
    }
 
    public mutating func normalize() -> CGVector {
        self = normalized()
        return self
    }
    
    static public func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }
    
    static public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }
    
    static public func *= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector * scalar
    }
}
