import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Герой
    var player:SKSpriteNode!
    
    //Для джостика
    let joystick = Joystick()
    var isMoving:Bool!
    
    //Камера
    let cam = SKCameraNode()
    
    var fon:SKSpriteNode!
    

    
    //Эта функция вызывается когда создается сцена, то есть самой первой
    override func didMove(to view: SKView) {
        
        //Инит героя
        player = SKSpriteNode(imageNamed: "1")
        player.physicsBody =  SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.position = CGPoint(x: 0, y: 0)
        self.addChild(player)
        
        //Инит джостика
        joystick.position = CGPoint(x: size.width/6-size.width/2, y:size.height/5-size.height/2)
        joystick.zPosition = 10
        addChild(joystick)
        isMoving = false
        
        //Инит говно фон
        fon = SKSpriteNode(imageNamed: "fon")
        fon.position = CGPoint(x: 0, y: 0)
        fon.zPosition = -10
        self.addChild(fon)
        //камера
        self.camera = cam
    
        //Физика
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) не разрешает выходить за границы экрана
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Перемещаем по джостику
        var flag:Bool!
        flag = true
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < 0 && location.y < size.height/6 {
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
            if location.x < 0 && location.y < size.height/6 {
                isMoving = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < -size.width/10 && location.y < size.height/6 {
                // Возвращем джостик в исходное положение,герой остановка
                isMoving = false
                joystick.stick.position = joystick.joystick.position
                player!.physicsBody!.isResting = true
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //cam.position = player.position следить за героем
    }
    
}
