import Foundation
import SpriteKit

class Joystick: SKNode {
    
    //tt
    var joystick =  SKShapeNode()
    var stick = SKShapeNode()
    
    let maxRange: CGFloat = 20
    
    var xValue: CGFloat = 0
    var yValue: CGFloat = 0
    
    //dop
    var joystickAction: ((_ x: CGFloat, _ y: CGFloat) -> ())?
    
//    func showJoystick(touch: UITouch) {
//        isHidden = false
//        position = touch.location(in: parent!)
//    }
    
    func moveJoystick(touch: UITouch) {
        let p = touch.location(in: self)
        let x = p.x.clamped(-maxRange, maxRange)
        let y = p.y.clamped(-maxRange, maxRange)
        
        stick.position = CGPoint(x: x, y: y)
        xValue = x / maxRange
        yValue = y / maxRange
        
        //dop
        if let joystickAction = joystickAction {
            joystickAction(xValue, yValue)
        }
    }
    
//    func hideJoystick() {
//        isHidden = true
//        stick.position = CGPoint.zero
//        xValue = 0
//        yvalue = 0
//    }
    
   
    override init() {
        
        let joystickRect = CGRect(x: 0, y: 0, width: 90, height: 90)
        let joystickPath = UIBezierPath(ovalIn: joystickRect)
        
        joystick = SKShapeNode(path: joystickPath.cgPath, centered: true)
        joystick.lineWidth = 2
        joystick.strokeColor = SKColor(white: 1, alpha: 0.5)
        //joystick.fillColor = SKColor.gray
        
     
        let stickRect = CGRect(x: 0, y: 0, width: 40, height: 40)
        let stickPath = UIBezierPath(ovalIn: stickRect)
        
        stick = SKShapeNode(path: stickPath.cgPath, centered: true)
        stick.fillColor = SKColor.gray
        stick.lineWidth = 4
        stick.strokeColor = SKColor(white: 0, alpha: 0.5)
        stick.alpha = 0.5
        
        super.init()
        
        addChild(joystick)
        joystick.addChild(stick)
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGFloat {
    
    public func clamped(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
//    public mutating func clamp(v1: CGFloat, _ v2: CGFloat) -> CGFloat {
//        self = clamped(v1, v2)
//        return self
//    }
//
}
