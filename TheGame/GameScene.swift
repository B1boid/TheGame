import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Герой
    var player:SKSpriteNode!
    
    //Для джостика
    let joystick = Joystick()
    var isMoving:Bool!
    
    //Эта функция вызывается когда создается сцена, то есть самой первой
    override func didMove(to view: SKView) {
        
        //Инит героя
        player = SKSpriteNode(imageNamed: "1")
        player.physicsBody =  SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.position = CGPoint(x: 0, y: 0)
        self.addChild(player)
        
        //Инит джостика
        joystick.position = CGPoint(x: size.width/6-size.width/2, y:size.height/6-size.height/2)
        addChild(joystick)
        isMoving = false
    
        //Физика
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Перемещаем по джостику
        if isMoving{
            joystick.moveJoystick(touch: touches.first!)
            joystick.joystickAction = {(x: CGFloat,y : CGFloat) in
            self.player.physicsBody?.velocity = (CGVector(dx: x*100, dy: y*100))}
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Чек область под джостик
            if location.x < -size.width/10 && location.y < size.height/6 {
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
    
    //Пока не использую нигде но пусть будет тут
    private func shouldMove(currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Тестил движение по нажатию на экран
//        if let touch = location {
//            let currentPosition = player!.position
//            if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
//                let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x)+CGFloat(Double.pi)
//                let velocotyX = playerSpeed * cos(angle)
//                let velocityY = playerSpeed * sin(angle)
//                let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
//                player.physicsBody?.velocity  = newVelocity
//            }else {
//                player!.physicsBody!.isResting = true
//            }
//        }
    }
    
}
