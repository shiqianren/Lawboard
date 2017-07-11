import UIKit

enum FlipperDirection {
    case top
    case bottom
}

protocol LawBoardPageFliperDatasource {
    func numberOfPagesForPageFlipper(pageFlipper: LawBoardPageFliper) -> Int
    func viewForPage(page: Int, pageFlipper: LawBoardPageFliper) -> UIView
}

/// 折叠翻页类实现
class LawBoardPageFliper: UIView {
    /// 当前页码
    internal var _currentPage: Int = 0
    
    var currentPage: Int {
        get {
            return _currentPage
        }
        set {
            _currentPage = newValue
            // 获取当前页面
            self.currentView = self.dataSource!.viewForPage(page: _currentPage, pageFlipper: self)
        }
    }
    
    /// 总页码
    var numbersOfPage: Int = 0
    
    /// 当前视图
    var currentView: UIView!
    
    /// 下一页视图
    var nextView: UIView!
    
    /// 翻页的数据源，获取页数和翻页前后页面的视图
    var dataSource: LawBoardPageFliperDatasource? {
        didSet {
            // 获取总页面数目
            self.numbersOfPage = self.dataSource!.numberOfPagesForPageFlipper(pageFlipper: self)
            
            //初始化当前页码
            self.currentPage = 1
            
            // 初始化折叠视图
            self.initFlip()
            
            self.initLayerContent()
        }
    }
    
    /// 折叠翻页方向
    var direction: FlipperDirection?
    
    /// 翻页开始时所点击的Y坐标，用于计算折叠方向
    var startY: CGFloat = 0.0
    
    /// 初始化函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 函数初始化，根据传递的两个点计算线性参数y = kx + b， 得到k和b
    internal var math: Math = Math((x : 0, degree : 0), (x : Height(), degree : 180))
    
    internal var topLayer: CALayer!
    internal var bottomLayer: CALayer!
    /// 动画layer
    internal var animateLayer: CALayer!
    internal var animateTopLayer: CALayer!
    internal var animateBottomLayer: CALayer!
    
    /// 初始化翻页折叠视图
    internal func initFlip() {
        let image = self.currentView.imageByRenderingView()
        let _ = Math.ResetFromSize(image.size, withFixedHeight: Height() / 2.0)
        
        var rect = self.bounds
        rect.size.height /= 2
        
        self.topLayer = CALayer()
        self.topLayer.frame = rect
        self.topLayer.masksToBounds = true
        self.topLayer.contentsGravity = kCAGravityTop
        self.layer.addSublayer(self.topLayer)
        
        rect.origin.y += rect.size.height
        
        self.bottomLayer = CALayer()
        self.bottomLayer.frame = rect
        self.bottomLayer.masksToBounds = true
        self.bottomLayer.contentsGravity = kCAGravityBottom
        self.layer.addSublayer(self.bottomLayer)
        
        animateLayer                        = CALayer()
        animateLayer.anchorPoint            = CGPoint(x: 0.5, y: 1)
        animateLayer.frame                  = CGRect(x: 0, y: 0, width: Width(), height: Height() / 2)
        animateLayer.allowsEdgeAntialiasing = true
        animateLayer.position               = CGPoint(x: self.middleX, y: Height() / 2)
        animateLayer.masksToBounds          = true
        animateLayer.transform              = CATransform3DMakeRotation(Math.RadianFromDegree(0), 1, 0, 1)
        self.layer.addSublayer(animateLayer)
        
        //为动画layer增加子layer，用于设置翻页时候显示的内容，因为涉及到一个layer正向显示，一个layer180翻转显示
        animateTopLayer = CALayer()
        animateTopLayer.frame = animateLayer.bounds
        animateTopLayer.masksToBounds = true
        animateTopLayer.allowsEdgeAntialiasing = true
        animateLayer.addSublayer(animateTopLayer)
        
        animateBottomLayer = CALayer()
        animateBottomLayer.frame = animateLayer.bounds
        animateBottomLayer.masksToBounds = true
        animateBottomLayer.allowsEdgeAntialiasing = true
        animateBottomLayer.transform = CATransform3DMakeRotation(Math.RadianFromDegree(180), 1, 0, 0)
        animateLayer.addSublayer(animateBottomLayer)
        
        animateTopLayer.isHidden = true
        animateBottomLayer.isHidden = true
        animateLayer.isHidden = true
    }
    
    /// 获取截取后的新图片，整体需求是要按照每个不同个layer进行大小裁剪
    ///
    ///     self.getNewImage(from: image, rect: CGRect(x: 0, y: 0, width: 200, height: 200))
    ///
    /// - Parameters:
    ///     - from: 原来的图像
    ///     - rect: 裁剪后的边界大小
    /// - Returns: 新图像
    internal func getNewImage(from image: UIImage, rect: CGRect) -> UIImage? {
        //return image
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: rect)
        context?.clip()
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    internal func getImage(from view: UIView, rect: CGRect) -> UIImage? {
        view.frame = rect
        return view.imageByRenderingView()
    }
    
    /// 设置顶部layer的内容
    ///
    ///     self.topLayerContents(set: someuiview)
    ///
    /// - Parameters:
    ///     - set: 需要设置的目标视图
    /// - Returns: LawboardPageFliper
    internal func topLayerContents(set view: UIView) -> LawBoardPageFliper {
//        let newImage = self.getNewImage(from: view.imageByRenderingView(), rect: self.topLayer.bounds)
        let newImage = self.getImage(from: view, rect: self.topLayer.bounds)
        self.topLayer.contents = newImage?.cgImage
        return self
    }
    
    /// 设置底部layer的内容
    ///
    ///     bottomLayerContents(set: someuiview)
    ///
    /// - Parameters:
    ///     - set: 需要设置的目标视图
    /// - Returns: LawboardPageFliper
    internal func bottomLayerContents(set view: UIView) -> LawBoardPageFliper {
        let newImage = self.getImage(from: view, rect: self.bottomLayer.bounds) //self.getNewImage(from: view.imageByRenderingView(), rect: self.bottomLayer.bounds)
        self.bottomLayer.contents = newImage?.cgImage
        return self
    }
    
    /// 设置动画顶部layer的内容
    ///
    ///     animateTopLayerContents(set: someuiview)
    ///
    /// - Parameters:
    ///     - set: 需要设置的目标视图
    /// - Returns: LawboardPageFliper
    internal func animateTopLayerContents(set view: UIView) -> LawBoardPageFliper {
        let newImage = self.getImage(from: view, rect: self.animateTopLayer.bounds)//self.getNewImage(from: view.imageByRenderingView(), rect: self.animateTopLayer.bounds)
        self.animateTopLayer.contents = newImage?.cgImage
        return self
    }
    
    /// 设置动画底部layer的内容
    ///
    ///     animateBottomLayerContents(set: someuiview)
    ///
    /// - Parameters:
    ///     - set: 需要设置的目标视图
    /// - Returns: LawboardPageFliper
    internal func animateBottomLayerContents(set view: UIView) -> LawBoardPageFliper {
        let newImage = self.getImage(from: view, rect: self.animateBottomLayer.bounds)//self.getNewImage(from: view.imageByRenderingView(), rect: self.animateBottomLayer.bounds)
        self.animateBottomLayer.contents = newImage?.cgImage
        return self
    }
    
    internal func initLayerContent() {
        let _ = self.topLayerContents(set: self.currentView).bottomLayerContents(set: self.currentView)
    }
    
    /// 设置滑动过程中的layer内容
    ///
    ///     self.setAnimatingLayerContent(FlipperDirection.top, true)
    ///
    /// - Parameters:
    ///     - direction: 滑动方向
    ///     - yInBottom: 当前y轴是否在底部
    internal func setAnimatingLayerContent(direction: FlipperDirection, yInBottom: Bool) {
        switch direction {
        case .bottom:
            print("bottom")
            let preview = self.dataSource?.viewForPage(page: self.currentPage - 1, pageFlipper: self)
            let _ = self.topLayerContents(set: preview!).animateTopLayerContents(set: self.currentView).animateBottomLayerContents(set: preview!)
        case .top:
            print("top")
            let nextView = self.dataSource?.viewForPage(page: self.currentPage + 1, pageFlipper: self)
            let _ = self.bottomLayerContents(set: nextView!).animateTopLayerContents(set: nextView!).animateBottomLayerContents(set: self.currentView)
        }
        
        animateLayer.isHidden = false
        
        if yInBottom == true {
            self.animateTopLayer.isHidden = true
            self.animateBottomLayer.isHidden = false
        } else {
            self.animateTopLayer.isHidden = false
            self.animateBottomLayer.isHidden = true
        }
    }
    
    /// 处理滑动屏幕事件
    ///
    ///     let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    ///     self.addGestureRecognizer(panGesture)
    ///
    /// - Parameters:
    ///     - sender: 事件发送类型
    @objc internal func handlePan(_ sender : UIPanGestureRecognizer) {
        let curPoint = sender.location(in: self)
        let y = curPoint.y
        
        if startY == 0 {
            startY = y
        }
        
        if (startY > 0 && (y - startY) > 0) {
            direction = FlipperDirection.bottom
        } else {
            direction = FlipperDirection.top
        }
        
        let yInBottom = y >= Height() / 2.0
        
        // 设置每个layer显示内容
        self.setAnimatingLayerContent(direction: direction!, yInBottom: yInBottom)
        
        // 初始化3D变换,获取默认值
        var perspectiveTransform = CATransform3DIdentity
        
        // 透视
        perspectiveTransform.m34 = -1.0 / 2000.0
        
        // 空间旋转
        perspectiveTransform = CATransform3DRotate(perspectiveTransform, -Math.RadianFromDegree(y * math.k), 1, 0, 0)
        CATransaction.setDisableActions(true)
        animateLayer.transform = perspectiveTransform
        
        if sender.state == .ended {
            // 初始化3D变换,获取默认值
            var perspectiveTransform = CATransform3DIdentity
            
            // 透视
            perspectiveTransform.m34 = -1.0 / 2000.0
            
            // 空间旋转
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, Math.RadianFromDegree(yInBottom ? 180 : 0), 1, 0, 0)
            
            CATransaction.setDisableActions(false)
            animateLayer.transform = perspectiveTransform
            
            //操作结束，变更当前页码
            switch direction! {
            case .top:
                if yInBottom == true {
                    return
                }
                
                self.currentPage += 1
                
                if self.currentPage > self.numbersOfPage {
                    self.currentPage = self.numbersOfPage
                }
            case .bottom:
                if yInBottom != true {
                    return
                }
                
                if self.currentPage > 1 {
                    self.currentPage -= 1
                }
            }
        }
    }

    /// 动画结束的时候需要隐藏所有layer，使得所有正常的视图可操作
}
