import UIKit
import SDWebImage

class LWheelVC: UIViewController {
    @IBOutlet var wheelBgImage: UIImageView!
    @IBOutlet var startImage: UIImageView!
    @IBOutlet var startImageLabel: UILabel!
    
    @IBOutlet var startLabel: UILabel!
    var wheelType = "normal"
    var wheelResult = [String:Any]()
    
    var timer = Timer()
    var wheelStopping = 0
    
    let api = LawBoardApi.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.delegate = self
        
        //初始化视图
        self.initView()
    }
    
    func initView() {
        self.wheelBgImage.snp.makeConstraints { make in
            var width = self.view.frame.width * 0.8
            
            if (LawBoardUtil.isPad()) {
                width = width * 0.85
            }
            
            make.width.height.equalTo(width)
            make.top.equalTo(self.view.snp.top).offset(LawBoardUtil.isPad() ? 15 : 15 * SCALE)
            make.centerX.equalTo(self.view)
        }
        
        //转盘奖项背景修改为从后端读取
        self.wheelBgImage.sd_setImage(with: URL(string: "https://helloboard.cn/uploadimages/zhuanpan.png"), placeholderImage: #imageLiteral(resourceName: "redpaper_wheel_bg"), options: SDWebImageOptions.refreshCached) { (image, error, cache, url) in
            if (error == nil) {
                //绑定点击事件
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
                self.startLabel.isUserInteractionEnabled = true
                self.startLabel.addGestureRecognizer(tapGestureRecognizer)
			
            }
        }
        
        
        
        self.startImage.snp.makeConstraints { make in
            var width = self.wheelBgImage.frame.width * 0.36
            
            if (LawBoardUtil.isPad()) {
                width = width * 0.85
            }
            
            make.width.height.equalTo(width)
            make.center.equalTo(self.wheelBgImage)
        }
        
        self.startLabel.snp.makeConstraints { make in
            make.width.height.centerX.centerY.equalTo(self.startImage)
        }
        
        let label1 = UILabel()
        label1.attributedText = LawBoardUtil.stringFromHtml(string: "<div style='color:#fff;text-align: center;text-decoration: underline;'>游戏规则</div>")
        label1.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.textAlignment = .center
        self.view.addSubview(label1)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gotoWheelRuleWebVC))
        label1.isUserInteractionEnabled = true
        label1.addGestureRecognizer(gestureRecognizer)
        
        
        let label2 = UILabel()
        label2.attributedText = LawBoardUtil.stringFromHtml(string: "<div style='color:#f2eb9f;text-align: center;'>点击上方”开始“启动抽奖</div>")
        label2.font = UIFont.systemFont(ofSize: 17)
        label2.numberOfLines = 0
        label2.lineBreakMode = .byWordWrapping
        self.view.addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "实物及虚拟电子券等奖励由上海宝竞网络科技有限公司提供，与苹果公司无关。活动最终解释权归上海宝竞网络科技有限公司所有"
        label3.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label3.font = UIFont.systemFont(ofSize: 12)
        label3.textAlignment = .center
        label3.numberOfLines = 0
        self.view.addSubview(label3)
        
        label1.snp.makeConstraints { make in
            make.top.equalTo(self.wheelBgImage.snp.bottom).offset(LawBoardUtil.isPad() ? 15 : 15 * SCALE)
            make.width.equalTo(self.view).offset(self.view.frame.width * -0.2)
            make.centerX.equalTo(self.view)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(15)
            make.width.equalTo(label1)
            make.centerX.equalTo(self.view)
        }
        label3.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(15)
            make.width.equalTo(label2)
            make.centerX.equalTo(self.view)
        }

    }

	
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //转动转盘
        let text = self.startLabel.text
        
        if (text == "开始") {
            api.canPlayWheel(type: self.wheelType, callback: {
                self.startImage.rotate360Degree(delegate: nil)
                self.startLabel.text = "停止"
				self.perform(#selector(LWheelVC.stopWheel), with: nil, afterDelay: 5)
            })
        }
        
        //if (text == "停止" && self.wheelStopping == 0) {
          //  self.wheelStopping = 1
            //api.getWheelPrize(type: self.wheelType, callback: { data in
            //    let prizeID = data["id"] as! Int
            //    let prizeCount = data["prize_type_count"] as! Int
            //    self.wheelResult = data
             //   let angle = Double(360 / prizeCount * (prizeID - 1) + 720)
              //  self.startImage.rotate360Degree(angle: angle, delegate: self)
            //})
        //}
    }
	
	func stopWheel(){
		
		
		let text = self.startLabel.text
		
		if (text == "停止" && self.wheelStopping == 0) {
			self.wheelStopping = 1
			api.getWheelPrize(type: self.wheelType, callback: { data in
				let prizeID = data["id"] as! Int
				let prizeCount = data["prize_type_count"] as! Int
				self.wheelResult = data
				let angle = Double(360 / prizeCount * (prizeID - 1) + 720)
				self.startImage.rotate360Degree(angle: angle, delegate: self)
			})
		}
		
	}
	
	
    /// MARK: 跳转到转盘游戏规则
    func gotoWheelRuleWebVC() {
        let webVC = LWebVC()
        webVC.navTitle = "游戏规则"
        webVC.url = "\(HTTP_API_HOST)/site/page/wheelrule"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.backItem?.title = "返回"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if (self.wheelType == "newuser") {
            self.title = "新人礼"
        } else {
            self.title = "大转盘"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showWheelResult":
            let controller = segue.destination as! LWheelResultVC
            controller.wheelData = sender as! [String:Any]
        default:
            break;
        }
    }
}

extension LWheelVC: CAAnimationDelegate {
    
    func checkRemain(timer: Timer) {
        self.performSegue(withIdentifier: "showWheelResult", sender: self.wheelResult)
        self.timer.invalidate()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.startLabel.text = "开始"
        self.wheelStopping = 0
        
        let prizeName = self.wheelResult["name"] as! String
        let prizeWin = self.wheelResult["win"] as! Int

        if (prizeWin == 1) {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkRemain(timer:)), userInfo: nil, repeats: true)
        } else {
            alert(msg: prizeName)
        }
    }
}
