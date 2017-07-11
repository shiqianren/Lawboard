import UIKit

extension UIView {
    // MARK: 渲染截取图片
    func imageByRenderingView() -> UIImage {
        let oldAlpha = self.alpha
        self.alpha = 1
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.alpha = oldAlpha
        return resultingImage!
    }
}
