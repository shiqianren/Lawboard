import UIKit

extension UIImageView {
    // MARK: 图片旋转
    /// 图片旋转
    /// 
    ///     UIImage.rotate(度数, 重复次数, 代理)
    ///
    private func rotate(angle: Double, repeatCount: Float, delegate: CAAnimationDelegate?) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = NSNumber(value: Double(angle) * M_PI / 180) // 旋转角度
        rotationAnimation.duration = 2 // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        if (repeatCount > 0) {
            rotationAnimation.repeatCount = repeatCount // 旋转次数
        }
        rotationAnimation.delegate = delegate
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.isRemovedOnCompletion = false
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// MARK: 360度旋转图片，不停旋转
    func rotate360Degree(delegate: CAAnimationDelegate?) {
        self.rotate(angle: 360 * M_PI, repeatCount: 100000, delegate: delegate)
    }
    
    /// MARK: 360度旋转图片，不重复，旋转角度后停止
    func rotate360Degree(angle: Double, delegate: CAAnimationDelegate?) {
        self.rotate(angle: angle, repeatCount: 0, delegate: delegate)
    }
    
    /// MARK: 停止旋转
    func stopRotate() {
        layer.removeAllAnimations()
    }
}
