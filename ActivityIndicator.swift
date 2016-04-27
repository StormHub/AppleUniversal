
import UIKit

public class ActivityIndicator: UIView {
    
    private struct Constants {
        static let defaultStrokeColor = UIColor.blueColor().CGColor
        static let defaultFillColor = UIColor.clearColor().CGColor
        
        static let defaultLineWidth = CGFloat(4)
        static let defaultRadius = CGFloat(14)
        
        static let startAngle = CGFloat(-M_PI / 2)  // Start circle from the top
        static let totalAngle = CGFloat(2 * M_PI)  // Full circle
        
        static let strokeColorPath = "strokeColor"
        static let strokeEndPath = "strokeEnd"
        static let rotationPath = "transform.rotation"
    }
    
    private let layerLoader = CAShapeLayer()
    private let layerSeparator = CAShapeLayer()
    
    public var progress:Float = 0 {
        didSet {
            progress = progress.between(0, 1)
            if !animating
                && superview != nil {
                layoutSubviews()
            }
        }
    }
    
    public var isAnimating: Bool {
        return animating
    }
    
    private var animating: Bool = false {
        didSet {
            if !animating {
                layoutSubviews()
            }
        }
    }
    
    public func endAnimation() {
        layerLoader.strokeEnd = 0.0
        layerSeparator.strokeEnd = 1
        
        layerLoader.removeAllAnimations()
        animating = false
    }
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    private class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }
    
    public func beginAnimation() {
        layerLoader.removeAllAnimations()
        
        layerSeparator.strokeEnd = 0
        layerLoader.strokeEnd = 1.0
        animating = true
        
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let totalSeconds = self.dynamicType.poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in self.dynamicType.poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * CGFloat(M_PI))
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(Constants.strokeEndPath, duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(Constants.rotationPath, duration: totalSeconds, times: times, values: rotations)
        animateStrokeHueWithDuration(totalSeconds * 5)
    }
    
    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times
        animation.values = values
        animation.calculationMode = kCAAnimationLinear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        
        layerLoader.addAnimation(animation, forKey: animation.keyPath)
    }
    
    private func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        
        let animation = CAKeyframeAnimation(keyPath: Constants.strokeColorPath)
        
        animation.keyTimes = (0 ... count).map { CFTimeInterval($0) / CFTimeInterval(count) }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).CGColor
        }
        
        animation.duration = duration
        animation.calculationMode = kCAAnimationLinear
        animation.repeatCount = Float.infinity
        
        layerLoader.addAnimation(animation, forKey: animation.keyPath)
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        if let newView = newSuperview {
            self.backgroundColor = UIColor.clearColor()
            self.frame = newView.frame
        }
    }
    
    private func getLayoutCenter(superView:UIView) -> CGPoint {
        let width = superView.bounds.width / 2 // Center of the super view
        let height = max(superView.bounds.height - Constants.defaultRadius, CGFloat(0))
        let origin = superView.bounds.origin
        
        let center = CGPoint(x: origin.x + width, y: origin.y + height)
        return center
    }
    
    override public func layoutSubviews() {
        if let superview = superview {
            if layerSeparator.superlayer == nil {
                superview.layer.addSublayer(layerSeparator)
            }
            if layerLoader.superlayer == nil {
                superview.layer.addSublayer(layerLoader)
            }
            
            let center = getLayoutCenter(superview)
            
            let endAngle = Constants.totalAngle *  CGFloat(progress) + Constants.startAngle
            let progressPath = UIBezierPath(arcCenter: center, radius: Constants.defaultRadius, startAngle: Constants.startAngle, endAngle: endAngle, clockwise: true)
            layerSeparator.fillColor = Constants.defaultFillColor
            layerSeparator.strokeColor = Constants.defaultStrokeColor
            layerSeparator.path = progressPath.CGPath
            
            let loaderEndAngle = Constants.startAngle + Constants.totalAngle
            let loaderPath = UIBezierPath(arcCenter: CGPointZero, radius: Constants.defaultRadius, startAngle: Constants.startAngle, endAngle: loaderEndAngle, clockwise: true)
            layerLoader.fillColor = Constants.defaultFillColor
            layerLoader.strokeColor = Constants.defaultStrokeColor
            layerLoader.path = loaderPath.CGPath
            layerLoader.position = center
            layerLoader.strokeEnd = 0.0 // Do not draw initially
        }
    }
}
