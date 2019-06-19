import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Герой
    var player:SKSpriteNode!
    
    //Для джостика
    let joystick = Joystick()
    var isMoving:Bool!
    let deltaJoystick = SKLabelNode() //это костыль,мы не будем пользоваться UI как таковым, у нас все расположения интерфейса будут высчитываться с помощью координат героя + дельты константы
    
    //Камера
    let cam = SKCameraNode()
    
    //Элементы карты
    var fon:SKSpriteNode!
    
    
    //Эта функция вызывается когда создается сцена, то есть самой первой
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
    
    func creatingPlayer(){
        player = SKSpriteNode(imageNamed: "1")
        player.physicsBody =  SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.position = CGPoint(x: 0, y: 0)
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
        fon.setScale(5)
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
                        self.player.physicsBody?.velocity = (CGVector(dx: x*100, dy: y*100))}
                }
            }
        }
        if flag {
            isMoving = false
            joystick.stick.position = joystick.joystick.position
            player!.physicsBody!.isResting = true
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
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = player.position
        joystick.position.x = player.position.x + deltaJoystick.position.x
        joystick.position.y = player.position.y + deltaJoystick.position.y
    }
    
    
    
}
