
import Alamofire

enum LawboardApiError: Error {
    case statusError
    case needLoginError
}

enum LoginUserType {
    case wechat
    case phone
}

// MARK: 萝卜基础后台数据请求类
/// 萝卜基础后台数据请求类
///
///     使用方式：（单例）LawBoardApi.shareInstance
///
class LawBoardApi {
    /// 基础请求URL
    private var baseUrl = "\(HTTP_API_HOST)/api"
	private var wentanUrl = "\(HTTP_API_HOST)"
	private var WENTANURLNEWLIST = "http://172.16.129.121:8181/datasub/article/news/list"
	
	private var WENTANNEWDETAIL  = "http://172.16.129.121:8181/datasub/article/"
    /// 单例
    static var shareInstance = LawBoardApi()
    
    /// 代理
    open weak var delegate: LawBoardApiDelegate?
    
    // MARK: 获取HTTP请求附加的已登录Token
    /// 获取HTTP请求附加的已登录Token
    ///
    ///     Alamofire.request("url", headers: self.tokenHeader())
    ///
    /// - Returns: 附加的HTTP Headers
    private func tokenHeader() -> HTTPHeaders {
        let accessToken = LawBoardStore.instance.getApiData(key: LawBoardStore.instance.KEY_API_ACCESS_TOKEN) as! String
        let headers: HTTPHeaders = [
            "Authorization": "HelloBoard \(accessToken)",
            "Accept": "application/json"
        ]
        return headers
    }
    
    // MARK: 验证登录用户的access token合法性
    open func registerDeviceToken(deviceToken: String, successCallback: @escaping () -> Void, failCallback: @escaping (_ msg: String) -> Void) {
        Alamofire.request(self.baseUrl + "/registerDeviceToken?device_token=\(deviceToken)").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    
                    if (status == 0) {
                        successCallback()
                    } else {
                        failCallback(jsonData["msg"] as! String)
                    }
                }
            } else {
                failCallback("网络异常，注册设备失败")
            }
        }
    }
    
    // MARK: 验证登录用户的access token合法性
    open func validAccessToken(successCallback: @escaping () -> Void, failCallback: @escaping () -> Void) {
        let accessToken = LawBoardStore.instance.getApiData(key: LawBoardStore.instance.KEY_API_ACCESS_TOKEN) as! String
        let loginUserId = LawBoardStore.instance.getApiData(key: LawBoardStore.instance.KEY_API_LOGIN_USER_ID) as! String
        
        Alamofire.request(self.baseUrl + "/auth/token/check?access_token=\(accessToken)&login_user_id=\(loginUserId)").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    
                    if (status == 0) {
                        successCallback()
                    } else {
                        failCallback()
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
            }
        }
    }
    
    // MARK: 刷新access token
    open func refreshToken(_ successCallback: @escaping () -> Void, _ failCallback: @escaping (_ msg: String) -> Void) {
        let refreshToken = LawBoardStore.instance.getApiData(key: LawBoardStore.instance.KEY_API_REFRESH_TOKEN) as! String
        let loginUserId = LawBoardStore.instance.getApiData(key: LawBoardStore.instance.KEY_API_LOGIN_USER_ID) as! String
        
        print("refresh_token:\(refreshToken) user_id:\(loginUserId)")
        
        Alamofire.request(self.baseUrl + "/auth/token/refresh?refresh_token=\(refreshToken)&login_user_id=\(loginUserId)").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    
                    if (status == 0) {
                        let data = jsonData["data"] as! [String:String]
                        LawBoardStore.instance.setApiData(access_token: data["access_token"]!, refresh_token: data["refresh_token"]!, login_user_id: data["login_user_id"]!, refresh: true)
                        successCallback()
                    } else {
                        failCallback(jsonData["msg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
            }
        }
    }

    
    // MARK: 需要登录的必须通过这个方法执行HTTP请求
    private func needLogin(_ callback: @escaping () -> Void) {
        //验证access token是否合法
        self.validAccessToken(successCallback: {
            callback()
        }, failCallback: {
            self.refreshToken({
                callback()
            }, { msg in
                self.delegate?.apiRequestError(msg: msg)
            })
        })
    }
    
    // MARK: 针对后台API微信登录授权
    open func userLogin(type: LoginUserType, extendData: [String:String]?, _ successCallback: @escaping () -> Void) {
        var parameters = Parameters()
        var url = ""
        
        switch type {
        case .phone:
            url = self.baseUrl + "/auth/phone/login"
            
            if (extendData != nil) {
                parameters = extendData!
            }
            break;
        case .wechat:
            url = self.baseUrl + "/auth/wechat/login"
            parameters = LawBoardStore.instance.getWechatData(key: nil) as! Parameters
            break
        }
        
        print(parameters)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
//            print(response.request)  // 请求对象
//            print(response.response) // 响应对象
//            print(response.data)     // 服务端返回的数据
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    if status == 0 {
                        let data = jsonData["data"] as! [String:String]
                        
                        LawBoardStore.instance.setApiData(access_token: data["access_token"]!, refresh_token: data["refresh_token"]!, login_user_id: data["login_user_id"]!, refresh: false)
                        
                        successCallback()
                    } else {
                        self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常，登录失败")
            }
        }
    }
    
    /// MARK: 账号绑定
    open func userBind(type: LoginUserType, extendData: [String:String]?, _ successCallback: @escaping () -> Void) {
        self.needLogin {
            var parameters = Parameters()
            var url = ""
            
            switch type {
            case .phone:
                url = self.baseUrl + "/auth/phone/bind"
                
                if (extendData != nil) {
                    parameters = extendData!
                }
                break;
            case .wechat:
                url = self.baseUrl + "/auth/wechat/bind"
                parameters = LawBoardStore.instance.getWechatData(key: nil) as! Parameters
                print(parameters)
                break
            }
            
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        if status == 0 {
                            successCallback()
                        } else {
                            self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常，登录失败")
                }
            }
        }
    }
    
    // MARK: 设置用户信息
    open func infoSet(data: [String:Any], _ successCallback: @escaping () -> Void) {
        self.needLogin {
            let parameters: Parameters = [
                "wx_openid": "",
                "open_openid": data["openid"] as! String,
                "nickname": data["nickname"] as! String,
                "sex": data["sex"] as! Int,
                "province": data["province"] as! String,
                "city": data["city"] as! String,
                "country": data["country"] as! String,
                "headimgurl": data["headimgurl"] as! String,
                "unionid": data["unionid"] as! String
            ]
            
            Alamofire.request(self.baseUrl + "/auth/wechat/info/set", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        if status == 0 {
                            print("success set user info")
                            successCallback()
                        } else {
                            LawBoardStore.instance.removeWechatData()
                            self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常")
                }
            }
        }
    }
    
    // MARK: [需要登录]获取是否已经得到新人礼
    open func isAlreadyGetNewUserGoldRadish(callback: @escaping (_ data: Int) -> Void) {
        self.needLogin {
            Alamofire.request(self.baseUrl + "/redpaper/wheel/isAlreadyGetNewUserGoldRadish", headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        if status == 0 {
                            callback(jsonData["data"] as! Int)
                        } else {
                            self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常")
                }
            }
        }
    }
    
    // MARK: [需要登录]获取转盘抽奖结果
    open func getWheelPrize(type: String, callback: @escaping (_ data: [String:Any]) -> Void) {
        self.needLogin {
            Alamofire.request(self.baseUrl + "/redpaper/wheel/getWheelPrize/\(type)", headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        if status == 0 {
                            callback(jsonData["data"] as! [String:Any])
                        } else {
                            self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
                }
            }
        }
    }
    
    // MARK: 发送短信验证码
    open func sendCodeSms(type:String, phone: String, callback: @escaping () -> Void) {
        let parameters: Parameters = [
            "type": type,
            "phone": phone
        ]
        
        Alamofire.request(self.baseUrl + "/sendCodeSms", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.tokenHeader()).responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    if status == 0 {
                        callback()
                    } else {
                        self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常, 发送验证码失败，请稍后重试")
            }
        }
    }
    
    // MARK: [需要登录]检测是否可以进行转盘
    open func canPlayWheel(type: String, callback: @escaping () -> Void) {
        self.needLogin {
            Alamofire.request(self.baseUrl + "/redpaper/wheel/canPlayWheel/\(type)", headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        
                        if status == 0 {
                            callback()
                        } else {
                            self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
                }
            }
        }
    }
    
    // MARK: [需要登录]获取中奖的红包数据
    open func getMyPrizeResult(callback: @escaping ([String:Any]) -> Void) {
        self.needLogin {
            Alamofire.request(self.baseUrl + "/redpaper/getMyPrizeResult", headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        if status == 0 {
                            callback(jsonData["data"] as! [String:Any])
                        } else {
                            self.delegate?.apiRequestError(msg: jsonData["msg"] as! String)
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
                }
            }
        }
    }
    
    //  MARK: 根据用户关注的兴趣进行新闻列表获取
    /// 根据用户关注的兴趣进行新闻列表获取
    /// 
    ///
    /// - Parameters:
    ///     - callback: 回调函数
    open func getNewList(callback: @escaping (_ data: [NewsDataModel]) -> Void) {
        let userDefaults = UserDefaults.standard
        let interestIds = userDefaults.array(forKey: "interest_ids") as? [Int] ?? []
        
        let parameters: Parameters = [
            "interest_ids": interestIds
        ]
        
        Alamofire.request(self.baseUrl + "/newlist", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    if status == 0 {
                        var newList = [NewsDataModel]()
                            
                        for item in jsonData["data"] as! [[String:Any]] {
                            newList.append(NewsDataModel(data: item))
                        }
                            
                        callback(newList)
                    } else {
                        self.delegate?.getNewListFailure!(msg: jsonData["msg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常：获取资讯列表失败")
            }
        }
    }
    
    /// 获取新闻单页信息
    ///
    /// - Parameters:
    ///     - id: 资讯的ID
    ///     - callback: 回调函数
    open func getNewItem(id: Int64, callback: @escaping (_ data: [String:Any]) -> Void) {
        Alamofire.request(self.baseUrl + "/new/\(id)").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    if status == 0 {
                        callback(jsonData["data"] as! [String:Any])
                    } else {
                        self.delegate?.getNewItemFailure!(msg: jsonData["msg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常：获取资讯信息失败")
            }
        }
    }
    
    /// 获取兴趣列表
    ///
    /// - Parameters:
    ///     - callback: 回调函数
    open func getInterestList(callback: @escaping (_ data: [[String:Any]]) -> Void) {
        Alamofire.request(self.baseUrl + "/interest").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    if status == 0 {
                        callback(jsonData["data"] as! [[String:Any]])
                    } else {
                        self.delegate?.getInterestListFailure!(msg: jsonData["msg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常：获取兴趣列表失败")
            }
        }
    }
    
    /// [需要登录]设置用户选取的兴趣
    /// - Parameters:
    ///     - selectIds: 关注的兴趣ID数组
    open func setUserInterest(selectIds: [Int]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: selectIds, options: .prettyPrinted)
            let jsonString = String(data: data, encoding: .utf8)
            let parameters: Parameters = [
                "select_ids": jsonString!
            ]
            
            Alamofire.request(self.baseUrl + "/user/interest", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.tokenHeader()).responseJSON { response in
                if "\(response.result)" == "SUCCESS" {
                    if let JSON = response.result.value {
                        let jsonData = JSON as! [String:Any]
                        let status = jsonData["status"] as! Int
                        if status == 1 {
                            print("\(jsonData["msg"])")
                        }
                    }
                } else {
                    self.delegate?.apiRequestError(msg: "网络异常：设置关注的兴趣失败")
                }
            }
        } catch {
            self.delegate?.apiRequestError(msg: "异常：\(error.localizedDescription)")
        }
    }
    
    // MARK: [需要登录]Follow系列方法的核心执行方法
    /// [需要登录]Follow系列方法的核心执行方法
    /// 
    /// - Parameters: 
    ///     - action: 动作，"follow"/"approve"
    ///     - object: 对象, "new"/"user"
    ///     - id: 对象ID
    ///     - type: 操作类型，"add"/"del"
    private func doFollowAction(action: String, object: String, id: Int64, type: String) {
        Alamofire.request(self.baseUrl + "/action/\(action)/\(object)/\(id)/\(type)", headers: self.tokenHeader()).responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let status = jsonData["status"] as! Int
                    if status == 1 {
                        self.delegate?.apiRequestError(msg: "网络异常：操作失败")
                    }
                }
            }
        }
    }
    
    // MARK: [需要登录]收藏资讯
    /// [需要登录]收藏资讯
    ///
    /// - Parameters:
    ///     - newId: 资讯ID
    open func followNew(newId: Int64) {
        self.doFollowAction(action: "follow", object: "new", id: newId, type: "add")
    }
    
    // MARK: [需要登录]取消收藏资讯
    /// [需要登录]取消收藏资讯
    ///
    /// - Parameters:
    ///     - newId: 资讯ID
    open func unFollowNew(newId: Int64) {
        self.doFollowAction(action: "follow", object: "new", id: newId, type: "del")
    }
    
    // MARK: [需要登录]关注用户
    /// [需要登录]关注用户
    ///
    /// - Parameters:
    ///     - userId: 用户ID
    open func followUser(userId: Int64) {
        self.doFollowAction(action: "follow", object: "user", id: userId, type: "add")
    }
    
    // MARK: [需要登录]取消关注用户
    /// [需要登录]取消关注用户
    ///
    /// - Parameters:
    ///     - userId: 用户ID
    open func unFollowUser(userId: Int64) {
        self.doFollowAction(action: "follow", object: "user", id: userId, type: "del")
    }
    
    // MARK: [需要登录]点赞资讯
    /// [需要登录]点赞资讯
    ///
    /// - Parameters:
    ///     - newId: 资讯ID
    open func approveNew(newId: Int64) {
        self.doFollowAction(action: "approve", object: "new", id: newId, type: "add")
    }
    
    // MARK: [需要登录]取消点赞资讯
    /// [需要登录]取消点赞资讯
    ///
    /// - Parameters:
    ///     - newId: 资讯ID
    open func unApproveNew(newId: Int64) {
        self.doFollowAction(action: "approve", object: "new", id: newId, type: "del")
    }
    
    /// ------------
    /// 微信相关接口
    /// ------------
    
    
    var openApiHttpHost = "https://api.weixin.qq.com"
    
    // MARK: 获取AccessToken
    open func wechatGetAccessToken(code: String, callback: @escaping () -> Void) {
        let parameters: Parameters = [
            "appid": WX_APPID,
            "secret": WX_APPSECRET,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        Alamofire.request(openApiHttpHost + "/sns/oauth2/access_token", parameters: parameters, headers: self.tokenHeader()).responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    
                    if (jsonData["errcode"] == nil) {
                        let access_token = jsonData["access_token"] as! String
                        let refresh_token = jsonData["refresh_token"] as! String
                        let openid = jsonData["openid"] as! String
                        let unionid = jsonData["unionid"] as! String
                        let expires_in = jsonData["expires_in"] as! Int
                        
                        //持久化
                        if (access_token.isEmpty == false && refresh_token.isEmpty == false && openid.isEmpty == false) {
                            LawBoardStore.instance.setWechatData(access_token: access_token, refresh_token: refresh_token, openid: openid, unionid: unionid, expires_in: expires_in)
                        }
                        
                        callback()
                    } else {
                        self.delegate?.apiRequestError(msg: jsonData["errmsg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "微信网络异常, 请稍后重试")
            }
        }
    }
    
    // MARK: 获取用户个人信息（UnionID机制）
    open func wechatLoginByRequestForUserInfo(callback: @escaping (_ data: [String:Any]) -> Void) {
        let accessToken = LawBoardStore.instance.getWechatData(key: LawBoardStore.instance.KEY_WECHAT_ACCESS_TOKEN) as! String
        let openId = LawBoardStore.instance.getWechatData(key: LawBoardStore.instance.KEY_WECHAT_OPENID) as! String
        
        // 获取用户信息
        let parameters: Parameters = [
            "access_token": accessToken,
            "openid": openId
        ]
        
        Alamofire.request(openApiHttpHost + "/sns/userinfo", parameters: parameters, headers: self.tokenHeader()).responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    
                    if jsonData["errcode"] == nil {
                        callback(jsonData)
                    } else {
                        self.delegate?.apiRequestError(msg: jsonData["errmsg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
            }
        }
    }
    
    // MARK: 刷新access token
    open func wechatRefreshToken(_ callback: @escaping () -> Void) {
        let refreshToken = LawBoardStore.instance.getWechatData(key: LawBoardStore.instance.KEY_WECHAT_REFRESH_TOKEN) as! String
        
        Alamofire.request(openApiHttpHost + "/sns/oauth2/refresh_token?appid=\(WX_APPID)&grant_type=refresh_token&refresh_token=\(refreshToken)").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    
                    if jsonData["errcode"] == nil {
                        let access_token = jsonData["access_token"] as! String
                        let refresh_token = jsonData["refresh_token"] as! String
                        let openid = jsonData["openid"] as! String
                        
                        //持久化
                        if (access_token.isEmpty == false && refresh_token.isEmpty == false && openid.isEmpty == false) {
                            LawBoardStore.instance.setWechatData(access_token: access_token, refresh_token: refresh_token, openid: openid, unionid: nil, expires_in: nil)
                        }
                        
                        callback()
                    } else {
                        self.delegate?.apiRequestError(msg: jsonData["errmsg"] as! String)
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
            }
        }
    }
	
	
	/// 获取资讯列表
	///
	/// - Parameters:
	///     - callback: 回调函数
	open func getNewsList(userId: String,pageSize:Int,pageNum:Int,callback: @escaping (_ data: [NewModel]) -> Void) {
		
		
		let parameters:Parameters = [
			"userId": "39",
			"page": pageNum,
			"size": pageSize
		]
		//self.wentanUrl + "/datasub/article/news/list"
		Alamofire.request(self.wentanUrl + "/datasub/article/news/list", method: .get, parameters: parameters).responseJSON { response in
			if "\(response.result)" == "SUCCESS" {
				if let JSON = response.result.value {
					let jsonData = JSON as! [String:Any]
					let status = jsonData["success"] as! Int
					if status == 1 {
						var newList = [NewModel]()
						let nesArray = jsonData["data"] as! [String:Any]
						let articleList = nesArray["articleList"] as! [[String:Any]]
						for item in  articleList{
							newList.append(NewModel(data: item))
						}
						
						callback(newList)
					} else {
						self.delegate?.getNewListFailure!(msg: jsonData["msg"] as! String)
					}
				}
			} else {
				self.delegate?.apiRequestError(msg: "网络异常：获取资讯列表失败")
			}
		}
	}
	
	//获取资讯详情
	open func getNewDetail(id: Int, callback: @escaping (_ data: [String:Any]) -> Void){
	//self.wentanUrl + "/datasub/article/\(id)"
		Alamofire.request(self.wentanUrl + "/datasub/article/\(id)").responseJSON { response in
			if "\(response.result)" == "SUCCESS" {
				if let JSON = response.result.value {
					let jsonData = JSON as! [String:Any]
					let status = jsonData["success"] as! Int
					if status == 1 {
						callback(jsonData["data"] as! [String:Any])
					} else {
						self.delegate?.getNewItemFailure!(msg: jsonData["msg"] as! String)
					}
				}
			} else {
				self.delegate?.apiRequestError(msg: "网络异常：获取资讯信息失败")
			}
		}
	
	}
	// 获取广告信息
	open func getAdvertise(callback: @escaping (_ data: [String]) -> Void){
	
		Alamofire.request(self.wentanUrl + "/datasub/adv/sources").responseJSON { response in
			if "\(response.result)" == "SUCCESS" {
				if let JSON = response.result.value {
					let jsonData = JSON as! [String:Any]
					let status = jsonData["success"] as! Int
					if status == 1 {
						callback(jsonData["data"] as! [String])
					} else {
						self.delegate?.getNewItemFailure!(msg: jsonData["msg"] as! String)
					}
				}
			} else {
				self.delegate?.apiRequestError(msg: "网络异常：获取广告信息失败")
			}
		}
		
		
		
	}
	
	
	

    // MARK: 验证登录用户的access token合法性
    open func wechatValidAccessToken(successCallback: @escaping () -> Void, failCallback: @escaping () -> Void) {
        let accessToken = LawBoardStore.instance.getWechatData(key: LawBoardStore.instance.KEY_WECHAT_ACCESS_TOKEN) as! String
        let openId = LawBoardStore.instance.getWechatData(key: LawBoardStore.instance.KEY_WECHAT_OPENID) as! String
        
        Alamofire.request(openApiHttpHost + "/sns/auth?access_token=\(accessToken)&openid=\(openId)").responseJSON { response in
            if "\(response.result)" == "SUCCESS" {
                if let JSON = response.result.value {
                    let jsonData = JSON as! [String:Any]
                    let errcode = jsonData["errcode"] as! Int
                    
                    if (errcode == 0) {
                        successCallback()
                    } else {
                        failCallback()
                    }
                }
            } else {
                self.delegate?.apiRequestError(msg: "网络异常, 请稍后重试")
            }
        }
    }
}
