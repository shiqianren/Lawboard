
import UIKit

class WXLoginVC: UIViewController {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var logo2ImageView: UIImageView!
    @IBOutlet var licenseLabel: UILabel!
    @IBOutlet var wxLoginBtn: UIButton!
    
    var phoneLoginBtn: UIButton!
    var isBind = false
    var wechatInstalled = false
    
    let api = LawBoardApi.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wechatInstalled = WXApi.isWXAppInstalled() == true
        
        self.initViews()
        api.delegate = self
        
        if (isBind == false) {
            //是否已经微信登录验证
            let accessToken = LawBoardStore.instance.getApiData(key: LawBoardStore.instance.KEY_API_ACCESS_TOKEN) as! String
            
            print("accesstoken: \(accessToken)")
            
            if (accessToken != "") {
//                let createTime = UserDefaults.standard.object(forKey: LawBoardStore.instance.KEY_API_CREATE_TIME) as! Date
//                
//                let dateComponentsFormatter = DateComponentsFormatter()
//                dateComponentsFormatter.allowedUnits = [.day]
//                var dayDiff = dateComponentsFormatter.string(from: Date(), to: createTime)
//                
//                if (dayDiff != nil) {
//                    dayDiff!.remove(at: dayDiff!.index(before: dayDiff!.endIndex))
//                }
//                
//                //refresh未过期
//                if (dayDiff != nil && Int(dayDiff!) != nil && Int(dayDiff!)! < 30) {
//                    DispatchQueue.main.async {
//                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVCID") as! LMainNavVC
//                        self.present(mainVC, animated: false, completion: nil)
//                    }
//                }
                
                api.refreshToken({
                    print("in here")
                    DispatchQueue.main.async {
                        print("in here 2")
                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVCID") as! LMainNavVC
                        self.present(mainVC, animated: false, completion: nil)
                    }
                }, { msg in
                    print("msg: \(msg)")
                })
            }
        }
    }
    
    /// MARK: 初始化视图页面
    func initViews() {
        if (isBind == false) {
            self.logoImageView.snp.makeConstraints { make in
                make.width.height.equalTo(self.view.frame.width * 0.4)
                make.topMargin.equalTo(HEIGHT * 0.2)
                make.centerX.equalTo(self.view)
            }
            
            self.logo2ImageView.snp.makeConstraints { make in
                make.width.centerX.equalTo(self.logoImageView)
                make.height.equalTo(self.view.frame.width * 0.16)
                make.top.equalTo(self.logoImageView.snp.bottom).offset(5 * SCALE)
            }
            
            if self.wechatInstalled { //App登录，已安装微信
                //按钮样式
                self.wxLoginBtn.isHidden = false
                self.wxLoginBtn.backgroundColor = #colorLiteral(red: 0.00734532997, green: 0.7373757958, blue: 0.04969378561, alpha: 1)
                self.wxLoginBtn.layer.cornerRadius = 6 * SCALE
                self.wxLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 6 * SCALE)
                self.wxLoginBtn.snp.makeConstraints { make in
                    make.width.equalTo(self.view.frame.width * 0.75)
                    make.height.equalTo(12 * SCALE)
                    make.centerX.equalTo(self.view)
                    make.top.equalTo(self.logo2ImageView.snp.bottom).offset(51 * SCALE)
                }
            } else { //App登录，未安装微信
                phoneLoginBtn = UIButton()
                phoneLoginBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                phoneLoginBtn.layer.cornerRadius = 6 * SCALE
                phoneLoginBtn.setTitle("手机登录", for: .normal)
                phoneLoginBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                phoneLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 6 * SCALE)
                self.view.addSubview(phoneLoginBtn)
                phoneLoginBtn.snp.makeConstraints { make in
                    make.width.equalTo(self.view.frame.width * 0.75)
                    make.height.equalTo(12 * SCALE)
                    make.centerX.equalTo(self.view)
                    make.top.equalTo(self.logo2ImageView.snp.bottom).offset(51 * SCALE)
                }
                phoneLoginBtn.addTarget(self, action: #selector(gotoPhoneLoginVC(sender:)), for: .touchUpInside)
                // 把微信登录的按钮隐藏掉
                self.wxLoginBtn.isHidden = true
            }
            
            //许可协议label样式及内容
            self.licenseLabel.isHidden = false
            self.licenseLabel.attributedText = LawBoardUtil.stringFromHtml(string: "<div style='text-align: center;color:#ffffff;'>已阅读并同意<span style='color: #f2eb9f;'>黑萝软件许可及服务协议</span></div>")
            self.licenseLabel.font = UIFont.systemFont(ofSize: 5 * SCALE)
            self.licenseLabel.snp.makeConstraints { make in
                make.width.equalTo(self.view.frame.width * 0.75)
                make.centerX.equalTo(self.view)
                
                if self.wechatInstalled {
                    make.top.equalTo(self.wxLoginBtn.snp.bottom).offset(5 * SCALE)
                } else {
                    make.top.equalTo(phoneLoginBtn.snp.bottom).offset(5 * SCALE)
                }
            }
        } else { //绑定微信页面
            self.logoImageView.snp.makeConstraints { make in
                make.width.height.equalTo(self.view.frame.width * 0.4)
                make.topMargin.equalTo(HEIGHT * 0.05)
                make.centerX.equalTo(self.view)
            }
            
            self.logo2ImageView.snp.makeConstraints { make in
                make.width.centerX.equalTo(self.logoImageView)
                make.height.equalTo(self.view.frame.width * 0.16)
                make.top.equalTo(self.logoImageView.snp.bottom).offset(5 * SCALE)
            }
            
            self.licenseLabel.isHidden = true
            let labelInfo = UILabel()
            labelInfo.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            labelInfo.textAlignment = .center
            labelInfo.font = UIFont.systemFont(ofSize: 7 * SCALE)
            labelInfo.numberOfLines = 0
            
            if self.wechatInstalled {//绑定微信页面，已安装微信
                //按钮样式
                self.wxLoginBtn.isHidden = false
                self.wxLoginBtn.backgroundColor = #colorLiteral(red: 0.00734532997, green: 0.7373757958, blue: 0.04969378561, alpha: 1)
                self.wxLoginBtn.layer.cornerRadius = 6 * SCALE
                self.wxLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 6 * SCALE)
                self.wxLoginBtn.setTitle("绑定微信", for: .normal)
                self.wxLoginBtn.snp.makeConstraints { make in
                    make.width.equalTo(self.view.frame.width * 0.75)
                    make.height.equalTo(12 * SCALE)
                    make.centerX.equalTo(self.logo2ImageView)
                    make.top.equalTo(self.logo2ImageView.snp.bottom).offset(LawBoardUtil.isPad() ? 15 * SCALE : 30 * SCALE)
                }
                labelInfo.text = "绑定微信领取现金红包"
            } else {//绑定微信页面，未安装微信
                self.wxLoginBtn.isHidden = true
                labelInfo.text = "红包需要安装微信，且微信登录后领取"
            }
            
            self.view.addSubview(labelInfo)
            labelInfo.snp.makeConstraints { make in
                make.width.equalTo(self.view.frame.width * 0.8)
                make.centerX.equalTo(self.view)
                
                if self.wechatInstalled {
                    make.top.equalTo(self.wxLoginBtn.snp.bottom).offset(5 * SCALE)
                } else {
                    make.top.equalTo(self.logo2ImageView.snp.bottom).offset(5 * SCALE)
                }
            }
        }
    }
    
    /// MARK: 跳转协议页面
    func gotoLicenseVC() {
        let webVC = LWebVC()
        webVC.navTitle = "许可及服务协议"
        webVC.url = LawBoardUtil.getUrl(shortUrl: "/license")
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    /// MARK: 进入手机登录页面
    func gotoPhoneLoginVC(sender: UIButton!) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LRegisterVCID") as! LRegisterVC
        vc.isBindPhone = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// MARK: 跳转到微信登录页面
    @IBAction func wxLogin(_ sender: UIButton) {
        // 如果在这里判断是否安装了微信，会报－canOpenURL: failed for URL: "weixin://app/wx5efead4057f98bc0/" - error: "This app is not allowed to query for scheme weixin"错误
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = isBind == false ? WECHAT_API_STATE_USERLOGIN : WECHAT_API_STATE_USERBIND
        //第三方向微信终端发送一个SendAuthReq消息结构
        if !WXApi.send(req) {
            alert(msg: "微信登录请求发起失败")
        }
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
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gotoLicenseVC))
        self.licenseLabel.isUserInteractionEnabled = true
        self.licenseLabel.addGestureRecognizer(gestureRecognizer)
        
        if (self.isBind == false) {
            if (self.navigationController?.isNavigationBarHidden == false) {
                self.navigationController?.setNavigationBarHidden(true, animated: animated)
            }
        }
    }
}
