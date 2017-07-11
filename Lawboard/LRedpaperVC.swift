
import UIKit

struct MenuModel {
    var image: UIImage?
    var text: String
    
    init(image: UIImage?, text: String) {
        self.image = image
        self.text = text
    }
}

class LRedpaperVC: UIViewController {
    var topView: UIView!
    var bottomView: UIView!
    @IBOutlet var statusView: UIView!
    
    //页面控制器
    @IBOutlet var pc: UIPageControl!
    
    //banner视图
    @IBOutlet var sv: UIScrollView!
    
    //定时器
    var timer: Timer = Timer()
    
    //banner个数
    var bannerCount = 2
    
    //菜单视图
    @IBOutlet var menuCollectionView: UICollectionView!
    
    //菜单数据源
    var collectionModels = [MenuModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(tabbarSelect), name: NSNotification.Name(rawValue: "backZixun"), object: nil)
		

        //验证如果是新人，第一次使用软件，那么进入到金萝卜页面
        let api = LawBoardApi.shareInstance
        api.delegate = self
        api.isAlreadyGetNewUserGoldRadish(callback: { data in
			
            if (data == 0) {
			self.performSegue(withIdentifier: "showNewUserRadishVC", sender: nil)
            }
        })
        
        //banner轮换
        self.sv.snp.makeConstraints { make in
            let width = self.view.frame.width
            var height = width * 0.78
            
            print(LawBoardUtil.isPad())
            
            if (LawBoardUtil.isPad()) {
                height = height * 0.7
            }
            
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.statusView.snp.bottom)
        }
        
        self.pc.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.centerX.equalTo(self.view)
            make.top.equalTo(self.sv.snp.bottom).offset(-30)
        }
        
        self.menuCollectionView.snp.makeConstraints { make in
            let width = self.view.frame.width * 0.85
            make.top.equalTo(self.sv.snp.bottom)
            make.width.equalTo(width)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }
        
        //添加菜单按钮数据
        collectionModels.append(MenuModel(image: #imageLiteral(resourceName: "redpaper_wheel_icon"), text: "大转盘"))
        collectionModels.append(MenuModel(image: #imageLiteral(resourceName: "redpaper_q&a_icon"), text: "竞猜抢红包"))
        collectionModels.append(MenuModel(image: #imageLiteral(resourceName: "redpaper_user_icon"), text: "我的红包"))
        collectionModels.append(MenuModel(image: #imageLiteral(resourceName: "redpaper_event_icon"), text: "活动预告"))
        collectionModels.append(MenuModel(image: nil, text: ""))
        collectionModels.append(MenuModel(image: #imageLiteral(resourceName: "redpaper_rules_icon"), text: "活动规则"))
        
        //设置数据源和代理
        self.menuCollectionView.dataSource = self
        self.menuCollectionView.delegate = self
        self.menuCollectionView.backgroundColor = UIColor.clear
        
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lineView.alpha = 0.5
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.width.equalTo(self.view)
            make.height.equalTo(0.5)
            make.centerY.equalTo(self.menuCollectionView).offset(5)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = (offsetX + width / 2) / width
        
        pc.currentPage = Int(index)
    }
	func tabbarSelect (){
	self.navigationController?.setNavigationBarHidden(true, animated: true)
	 self.tabBarController?.selectedIndex = 1
	}
	
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(LRedpaperVC.nextImage), userInfo: nil, repeats: true)
    }
    
    func removeTimer() {
        timer.invalidate()
    }
    
    func nextImage() {
        var pageIndex = pc.currentPage
        if (pageIndex == (self.bannerCount - 1)) {
            pageIndex = 0
        } else {
            pageIndex += 1
        }
        pc.currentPage = pageIndex
        
        let offsetX = CGFloat(pageIndex) * self.view.frame.width
        sv.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    /// MARK: 跳转到webVC方法
    func gotoWebVC(title: String, shortUrl: String) {
        let webVC = LWebVC()
        webVC.navTitle = title
        webVC.url = "\(HTTP_API_HOST)/site\(shortUrl)"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.isNavigationBarHidden == false) {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        for i in 1...self.bannerCount { //loading the images
            let x = CGFloat(i - 1) * self.view.frame.width //这一步获取ScrollView的宽度时我用IPHONE6实体机测试是320，右边会出现第二张图片的一部分，最后还是用ROOT VIEW的宽度
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: self.view.frame.width, height: sv.bounds.height))
			print(LawBoardUtil.getImageUrl(filename: "banner\(i)"))
            imageView.sd_setImage(with: URL(string: LawBoardUtil.getImageUrl(filename: "banner\(i)")))
            
            sv.isPagingEnabled = true
            sv.showsHorizontalScrollIndicator = false
            sv.isScrollEnabled = true
            sv.addSubview(imageView)
            sv.delegate = self
        }
        
        sv.contentSize = CGSize(width: (self.view.frame.width * CGFloat(self.bannerCount)), height: sv.frame.height)
        pc.numberOfPages = self.bannerCount
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        removeTimer()
        addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeTimer()
    }
}

extension LRedpaperVC:UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModels.count
    }
    
    /// MARK: 设置菜单item样式
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        collectionView.layer.borderWidth = 0.5
//        collectionView.layer.borderColor = UIColor.blue.cgColor
        
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "RedpaperMenuCellID", for: indexPath) as! RedpaperMenuCell
    
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.white.cgColor
        cell.update(image: collectionModels[indexPath.row].image, text: collectionModels[indexPath.row].text)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    /// MARK: 设置底部菜单按钮
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //转盘
            self.performSegue(withIdentifier: "showWheelView", sender: nil)
        case 1: //竞猜抢红包
            self.gotoWebVC(title: "竞猜抢红包", shortUrl: "/event/guess")
        case 2: //我的红包
            self.performSegue(withIdentifier: "showMyPrizeResultVC", sender: nil)
        case 3: //活动预告
            self.gotoWebVC(title: "活动预告", shortUrl: "/event/notice")
        case 5: //活动规则
            self.gotoWebVC(title: "活动规则", shortUrl: "/event/rule")
        default:
            break;
        }
    }
}

extension LRedpaperVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame  = self.menuCollectionView.frame;
        var width = frame.width
        width = CGFloat(width/3)
        
        let height = (collectionView.bounds.height - tabBarController!.tabBar.bounds.height - CGFloat(30)) / 2
        return CGSize(width: width, height: height)
    }
}
