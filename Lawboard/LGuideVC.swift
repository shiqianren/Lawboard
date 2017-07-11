
import UIKit

class LGuideVC: UIViewController, UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var btnSubmit:UIButton?
    
    var btnList = [Int:UIButton]()
    
    var mDatas = [String]()
    
    var countdownTimer: Timer = Timer()
    var button = UIButton()
    var remainingSeconds = 0 {
        willSet {
            if newValue <= 0 {
                self.gotoWechatLoginVC()
            }
            button.setTitle("跳过(\(newValue)s)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        //Creating some shorthand for these values
        let wBounds = self.view.bounds.width
        let hBounds = self.view.bounds.height
        
        // This houses all of the UIViews / content
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.frame = self.view.frame
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        
        self.scrollView.contentSize = CGSize(width: wBounds * CGFloat(mDatas.count), height: hBounds/2)
        
        //点指示器
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 0, y: hBounds-35, width: wBounds, height: 0)
        pageControl.backgroundColor = UIColor(white: 0, alpha: 0)
        pageControl.numberOfPages = mDatas.count
        pageControl.currentPage = 0
		pageControl.isHidden = true
        pageControl.currentPageIndicatorTintColor = UIColor(red:0.325, green:0.667, blue:0.922, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        
        //根据数据数量来动态创建视图
        let size = mDatas.count
        for count in 0 ..<  size {
            let view = UIView()
            view.backgroundColor = UIColor.white
            //设置左边距离，根据数据对应数组的位置
            let lBounds = wBounds * CGFloat(count)
            view.frame = CGRect(x: lBounds, y: 0, width: wBounds, height: hBounds)
            
            let path = mDatas[count]
            let image = UIImage(named: path as String)
            let insets = UIEdgeInsetsMake(0, 0, 0, 0)
            //这里设置图片拉伸
            image?.resizableImage(withCapInsets: insets, resizingMode: UIImageResizingMode.stretch)
            let imageView = UIImageView.init()
			
            imageView.frame = CGRect(x: 0, y: 0, width: wBounds, height: hBounds)
			
			//imageView.image = UIImage(contentsOfFile:ImageTool.IMG_PATH)
			
			imageView.sd_setImage(with: URL(string: path as String)) { (image, error, cache, url) in
				if (error != nil) {
					//self.alert(msg: "加载图片失败")
				}
			}
			
			
            view.addSubview(imageView)
            
            
            
            if self.btnList.count > 0 {
                let btn = self.btnList[count]
                
                if btn != nil {
                    view.addSubview(btn!)
                }
            }
            
            if((self.btnSubmit) != nil && count == size-1){
                view.addSubview(self.btnSubmit!)
            }
            
            //把视图加入到scrollView中
            self.scrollView.addSubview(view)
            self.scrollView.bringSubview(toFront: view)
        }
        
        button.setTitle("跳过(10s)", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skipBtnClick(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.topMargin.equalTo(40)
            make.rightMargin.equalTo(-10)
        }
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(timer:)), userInfo: nil, repeats: true)
        
        remainingSeconds = 5
    }
    
    func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    func skipBtnClick(sender: UIButton!) {
        self.gotoWechatLoginVC()
    }
    
    /// MARK: 跳转到微信登录界面
    func gotoWechatLoginVC() {
        countdownTimer.invalidate()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WXLoginNAVVCID") as! WXLoginNAVVC
        self.present(vc, animated: false, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let xOffset: CGFloat = scrollView.contentOffset.x
        let x: Float = Float(xOffset)
        let width:Float = Float(self.view.bounds.width)
        
        pageControl.currentPage = Int(x / width)
        
    }
}
