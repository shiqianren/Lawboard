import UIKit

class LMyPrizeResultVC: UIViewController {

    @IBOutlet var radishCountContainerView: UIView!
    @IBOutlet var prizeResultTableView: UITableView!
    @IBOutlet var radishCount: UILabel!
    @IBOutlet var radishImageView: UIImageView!
    
    var registerBtn: UIButton!
    var prizeResultData = [[String:Any]]()
    
    var phoneValidted = 0
    var wechatValidated = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prizeResultTableView.dataSource = self
        self.prizeResultTableView.delegate = self
        self.prizeResultTableView.backgroundColor = UIColor.clear
        
        //设置点击事件
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gotoFinalPrizeVC))
        self.radishCount.isUserInteractionEnabled = true
        self.radishCount.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.gotoFinalPrizeVC))
        self.radishImageView.isUserInteractionEnabled = true
        self.radishImageView.addGestureRecognizer(gestureRecognizer2)
        
        let api = LawBoardApi.shareInstance
        api.delegate = self
        api.getMyPrizeResult(callback: { data in
            let radishCount = data["gold_radish_count"] as! Int
            self.phoneValidted = data["phone_validated"] as! Int
            self.wechatValidated = data["wechat_validated"] as! Int
            self.prizeResultData = data["prize_result_data"] as! [[String:Any]]
            
            //设置金萝卜数量
            self.radishCount.text = "\(radishCount)"
            
            //重新加载奖品表格数据
            self.prizeResultTableView.reloadData()
            
            //根据用户是否手机绑定决定是否显示绑定按钮
            self.initView()
        })
    }
    
    func initView() {
        if (phoneValidted == 0) {
            self.prizeResultTableView.snp.makeConstraints { make in
                make.centerX.width.equalTo(self.radishCountContainerView)
                make.top.equalTo(self.radishCountContainerView.snp.bottom).offset(5 * SCALE)
            }
            
            self.registerBtn = UIButton()
            self.registerBtn.setTitle("点击注册，查看领取我的红包", for: .normal)
            self.registerBtn.layer.cornerRadius = NORMAL_BTN_RADIUS
            self.registerBtn.layer.borderColor = UIColor.white.cgColor
            self.registerBtn.layer.borderWidth = 1
            self.registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 7 * SCALE)
            self.registerBtn.addTarget(self, action: #selector(self.gotoRegisterVC(sender:)), for: .touchUpInside)
            self.view.addSubview(self.registerBtn)
            self.registerBtn.snp.makeConstraints { make in
                make.width.equalTo(self.view.frame.width * 0.7)
                make.height.equalTo(NORMAL_BTN_HEIGHT)
                make.centerX.equalTo(self.view)
                make.top.equalTo(self.prizeResultTableView.snp.bottom).offset(5 * SCALE)
                make.bottom.equalTo(self.view.snp.bottom).offset(-5 * SCALE)
            }
        } else {
            self.prizeResultTableView.snp.makeConstraints { make in
                make.centerX.width.equalTo(self.radishCountContainerView)
                make.top.equalTo(self.radishCountContainerView.snp.bottom).offset(5 * SCALE)
                make.bottom.equalTo(self.view).offset(-5 * SCALE)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// MARK: 跳转到终极财富大奖说明页面
    func gotoFinalPrizeVC() {
        let webVC = LWebVC()
        webVC.navTitle = "终极故事霸王"
        webVC.url = LawBoardUtil.getUrl(shortUrl: "/event/final")
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    /// MARK: 注册按钮点击事件
    func gotoRegisterVC(sender: UIButton!) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "LRegisterVCID") as! LRegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    /// MARK: 翻页按钮响应事件
    func backAction() {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
	
	func backZixun(){
		
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backZixun"), object: nil, userInfo: nil)
		let _ =  self.navigationController?.popViewController(animated: false)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backAction))
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "资讯", style: .plain, target: self, action: #selector(backZixun))

        self.title = "我的红包"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension LMyPrizeResultVC: UITableViewDataSource, UITableViewDelegate {
    /// MARK: cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 0.4
    }
    
    /// MARK: 设置单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeResultTableCellID") as! PrizeResultTableCell
        cell.layer.cornerRadius = 5
        
        let name = self.prizeResultData[indexPath.row]["name"] as! String
        let imageName = self.prizeResultData[indexPath.row]["image"] as! String
        let value = self.prizeResultData[indexPath.row]["value"] as! String
        
        cell.update(image: imageName, name: name, value: value)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// MARK: 表格数据总数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.prizeResultData.count
    }
    
    /// MARK: 单元格点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prizeType = self.prizeResultData[indexPath.row]["type"] as! Int
        
        //如果获奖类型为红包，那么跳转到红包绑定说明页面
        if (prizeType == 1) {
            if (self.wechatValidated == 1) {//微信注册过的用户直接跳转到说明页面
                let webVC = LWebVC()
                webVC.navTitle = "账号绑定"
                webVC.url = LawBoardUtil.getUrl(shortUrl: "/help/followmp")
                self.navigationController?.pushViewController(webVC, animated: true)
            } else {//微信没有注册的引导用户进行微信绑定注册
                let wxLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "WXLoginVCID") as! WXLoginVC
                wxLoginVC.isBind = true
                self.navigationController?.pushViewController(wxLoginVC, animated: true)
            }
        } else { //其他类型直接跳转到奖券信息页面
            let prizeInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "LPrizeInfoVCID") as! LPrizeInfoVC
            prizeInfoVC.prizeName = self.prizeResultData[indexPath.row]["name"] as! String
            prizeInfoVC.prizeImageName = self.prizeResultData[indexPath.row]["image"] as! String
            prizeInfoVC.prizeContent = self.prizeResultData[indexPath.row]["content"] as! String
            self.navigationController?.pushViewController(prizeInfoVC, animated: true)
        }
    }
}
