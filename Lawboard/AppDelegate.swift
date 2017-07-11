
import UIKit
import Presentation

var LAWBOARD_DB_USER: [String:Any]?
var WX_APPID = "wx65b1913cfc61e653"
var WX_APPSECRET = "51e2e339e395557c764bb49631ce054c"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //注册通知服务
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
		
		//注册版本更新
		let siren = Siren.shared
		siren.alertType = .option
		siren.delegate = self
		// Optional
		siren.debugEnabled = true
		siren.forceLanguageLocalization = Siren.LanguageType.ChineseSimplified
		siren.majorUpdateAlertType = .option
		siren.minorUpdateAlertType = .option
		siren.patchUpdateAlertType = .option
		siren.revisionUpdateAlertType = .option
		siren.checkVersion(checkType: .immediately)
		
		
		
        //设置状态栏文字颜色为白色
        UIApplication.shared.statusBarStyle = .lightContent
        
        //向微信注册应用
        // @param1 微信开发者ID
        WXApi.registerApp(WX_APPID)
		
		//self.getAdv()
	
		print(LawBoardStore.instance.getFirstUse())
        // 验证用户是否第一次使用App
        if (LawBoardStore.instance.getFirstUse() == true) {
			
            
            let btnWidth:CGFloat = 250.0
            let btnHeight:CGFloat = 50.0
            let btnX:CGFloat = (UIScreen.main.bounds.width - btnWidth)/2
            let btnY:CGFloat = UIScreen.main.bounds.height - btnHeight - 100
            
            //引导页面button（1）
            let btnSubmit = UIButton(frame: CGRect(origin: CGPoint(x: btnX, y: btnY), size:CGSize(width: btnWidth, height: btnHeight)))
            btnSubmit.setTitle("开启红包之旅", for: UIControlState())
            btnSubmit.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState())
            btnSubmit.setTitleColor(UIColor.green, for: UIControlState.highlighted)
            btnSubmit.layer.backgroundColor = #colorLiteral(red: 0.00734532997, green: 0.7373757958, blue: 0.04969378561, alpha: 1).cgColor
            btnSubmit.layer.cornerRadius = btnHeight/2
            btnSubmit.tag = 1
            btnSubmit.addTarget(self, action: #selector(AppDelegate.onClick(sender:)), for: UIControlEvents.touchUpInside)
            
            //引导页面button（2）
            let btnSubmit2 = UIButton(frame: CGRect(origin: CGPoint(x: btnX, y: btnY - 100), size:CGSize(width: btnWidth, height: btnHeight)))
            btnSubmit2.setTitle("开始使用", for: UIControlState())
            btnSubmit2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState())
            btnSubmit2.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: UIControlState.highlighted)
            btnSubmit2.layer.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor
            btnSubmit2.layer.cornerRadius = btnHeight/2
            btnSubmit2.tag = 0
            btnSubmit2.addTarget(self, action: #selector(AppDelegate.onClick(sender:)), for: UIControlEvents.touchUpInside)
            
            //注册controller
			let guidePageController: LGuideVC = LGuideVC()
			
		    /*let  filePath = ImageTool.getfilePath(imgName: "adImageName")
		    let  isExit =  ImageTool.isFileExits(filePath: filePath)
			
			
			if ImageTool.isExistsSplashData() {
			//显示界面
				var mGuideImages = [String]()
				mGuideImages.append(ImageTool.IMG_PATH)
				guidePageController.mDatas = mGuideImages
				self.window!.rootViewController = guidePageController
				
				self.window!.backgroundColor = UIColor.white
				self.window!.makeKeyAndVisible()
			}
			*/
			
			
			LawBoardApi.shareInstance.getAdvertise { (data) in
				print(data[0] )
				var mGuideImages = [String]()
				mGuideImages.append(data[0])
				guidePageController.mDatas = mGuideImages
				self.window!.rootViewController = guidePageController
				self.window!.backgroundColor = UIColor.white
				self.window?.makeKeyAndVisible()
				
				/*
				ImageTool.updateSplashData(imgUrl: data[0], actUrl: "")
				print("重新加载图片了")
				let strArr = data[0].components(separatedBy: "/")
				let  isExit =  ImageTool.isFileExits(filePath: filePath)
				if isExit == false{
					ImageTool.downloadImage(imageUrl: data[0], iamgeName: strArr.last!)
				}else {
					ImageTool.deleteOldImage()
				}
*/
				/*
				var mGuideImages = [String]()
				guidePageController.mDatas = mGuideImages
				self.window!.rootViewController = guidePageController
				
				self.window!.backgroundColor = UIColor.white
				self.window!.makeKeyAndVisible()*/
			}
			
			//            guidePageController.btnList[2] = btnSubmit2
//            guidePageController.btnSubmit = btnSubmit

        } else {
            self.checkUserAndGotoView(index: 1)
        }
        
        return true
    }
    
    /// MARK: 注册远程通知服务
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    /// MARK: 处理device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let nsdataStr = NSData.init(data: deviceToken)
        let token = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        let standard = UserDefaults.standard
        if (standard.string(forKey: "device_token") == nil) {
            LawBoardApi.shareInstance.registerDeviceToken(deviceToken: token, successCallback: {
            }, failCallback: { msg in
                standard.set(token, forKey: "device_token")
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
                    
                    var hostVC = UIApplication.shared.keyWindow?.rootViewController
                    while let next = hostVC?.presentedViewController {
                        hostVC = next
                    }
                    hostVC?.present(alertVC, animated: true, completion: nil)
                }
            })
        }
    }
    
    /// MARK: 接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let infoData = userInfo[AnyHashable("aps")] as! [String:Any]
        let alert = infoData["alert"] as! String
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "", message: alert, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
            
            var hostVC = UIApplication.shared.keyWindow?.rootViewController
            while let next = hostVC?.presentedViewController {
                hostVC = next
            }
            hostVC?.present(alertVC, animated: true, completion: nil)
        }
    }
	
	
	func getAdv(){
		
		LawBoardApi.shareInstance.getAdvertise { (data) in
			print(data[1] )
		}
		
	}
	
    // MARK: 检查用户兴趣信息并进行页面跳转
    func checkUserAndGotoView(index: Int) {
        switch index {
        case 100: //绑定微信回来的页面跳转到我的红包页面
            let vc = self.storyboard.instantiateViewController(withIdentifier: "LMainNavVCID") as! LMainNavVC
            vc.tag = index
            self.window!.rootViewController = vc
            break;
        default: //默认其他页面都统一从微信登录页面跳转
            let wxLoginVC = self.storyboard.instantiateViewController(withIdentifier: "WXLoginNAVVCID")
            self.window!.rootViewController = wxLoginVC
            break;
        }
    }
    
    // MARK: 引导页面的按钮点击事件
    func onClick(sender: UIButton!) {
        LawBoardStore.instance.setFirstUse()
        
        self.checkUserAndGotoView(index: sender.tag)
    }
    
    /// MARK: 微信登录回调
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
        
        
        // 如需要使用其他第三方可以 使用 || 连接 其他第三方库的handleOpenURL
        // return WechatManager.sharedInstance.handleOpenURL(url) || TencentOAuth.HandleOpenURL(url) || WeiboSDK.handleOpenURL(url, delegate: SinaWeiboManager.sharedInstance) ......
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
		Siren.shared.checkVersion(checkType: .immediately)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		Siren.shared.checkVersion(checkType: .daily)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

/// MARK: 微信登录相关代理方法
extension AppDelegate: WXApiDelegate {
    public func onReq(_ req: BaseReq) {
//        if let temp = req as? ShowMessageFromWXReq {
//        }
    }
    
    ///  MARK: 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    public func onResp(_ resp: BaseResp) {
        print("onResp")
        if resp.isKind(of: SendAuthResp.self) {
            let authResp = resp as! SendAuthResp
            print("ErrCode : \(authResp.errCode); EodeStr : \(authResp.errStr); Code : \(authResp.code); State : \(authResp.state); Lang : \(authResp.lang); Country : \(authResp.country)")
            
            if authResp.errCode == 0 {
                let code = authResp.code
                
                let api = LawBoardApi.shareInstance
                api.delegate = self
                //获取access token
                api.wechatGetAccessToken(code: code!, callback: {
                    switch(authResp.state) {
                    case WECHAT_API_STATE_USERLOGIN:
                        api.userLogin(type: .wechat, extendData: nil, {
                            //获取用户信息
                            api.wechatLoginByRequestForUserInfo { data in
                                //处理App自定义逻辑
                                api.infoSet(data: data, {
                                    //跳转到WX登录页面
                                    self.checkUserAndGotoView(index: 1)
                                })
                            }
                        })
                        break;
                    case WECHAT_API_STATE_USERBIND:
                        api.userBind(type: .wechat, extendData: nil, {
                            //获取用户信息
                            api.wechatLoginByRequestForUserInfo { data in
                                //处理App自定义逻辑
                                api.infoSet(data: data, {
                                    //跳转到WX登录页面
                                    self.checkUserAndGotoView(index: 1)
                                })
                            }
                        })
                        break;
                    default:
                        print("非合法的微信登录")
                        break;
                    }
                })
            }
        }
    }
}


extension AppDelegate: LawBoardApiDelegate {
    func apiRequestError(msg: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
            
            var hostVC = UIApplication.shared.keyWindow?.rootViewController
            while let next = hostVC?.presentedViewController {
                hostVC = next
            }
            hostVC?.present(alertVC, animated: true, completion: nil)
        }
    }
}
extension AppDelegate: SirenDelegate
{
	func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
		print(#function, alertType)
	}
	
	func sirenUserDidCancel() {
		print(#function)
	}
	
	func sirenUserDidSkipVersion() {
		print(#function)
	}
	
	func sirenUserDidLaunchAppStore() {
		print(#function)
	}
	
	func sirenDidFailVersionCheck(error: NSError) {
		print(#function, error)
	}
	
	func sirenLatestVersionInstalled() {
		print(#function, "Latest version of app is installed")
	}
	
	// This delegate method is only hit when alertType is initialized to .none
	func sirenDidDetectNewVersionWithoutAlert(message: String) {
		print(#function, "\(message)")
	}
}
extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
