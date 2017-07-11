import Foundation

class LawBoardStore {
    static var instance = LawBoardStore()
    
    // MARK: 获取字符串数据，如果不存在则返回空
    public func getStringWithDefault(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    let KEY_FIRST_USRE = "first_use"
    
    // MARK: 获取是否是第一次使用软件
    public func getFirstUse() -> Bool {
//        let value = UserDefaults.standard.value(forKey: self.KEY_FIRST_USRE)
//        return value == nil ? true : false
        return true
    }
    
    // MARK: 设置非第一次使用软件
    public func setFirstUse() {
        UserDefaults.standard.set(true, forKey: self.KEY_FIRST_USRE)
    }
    
    
    let KEY_API_LOGIN_USER_ID = "api_login_user_id"
    let KEY_API_ACCESS_TOKEN = "api_access_token"
    let KEY_API_REFRESH_TOKEN = "api_refresh_token"
    let KEY_API_CREATE_TIME = "api_create_time"
    
    // MARK: 设置后端接口授权数据
    public func setApiData(access_token: String, refresh_token: String, login_user_id: String, refresh: Bool) {
        UserDefaults.standard.set(access_token, forKey: self.KEY_API_ACCESS_TOKEN)
        UserDefaults.standard.set(refresh_token, forKey: self.KEY_API_REFRESH_TOKEN)
        UserDefaults.standard.set(login_user_id, forKey: self.KEY_API_LOGIN_USER_ID)
        
        if (refresh == false) {
            UserDefaults.standard.set(Date(), forKey: self.KEY_API_CREATE_TIME)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 获取后端接口授权数据
    public func getApiData(key: String?) -> Any {
        if (key != nil) {
            return self.getStringWithDefault(key: key!)
        } else {
            return [
                "access_token": self.getStringWithDefault(key: self.KEY_API_ACCESS_TOKEN),
                "refresh_token": self.getStringWithDefault(key: self.KEY_API_REFRESH_TOKEN),
                "login_user_id": self.getStringWithDefault(key: self.KEY_API_LOGIN_USER_ID),
                "create_time": self.getStringWithDefault(key: self.KEY_API_CREATE_TIME)
            ]
        }
    }
    
    // MARK: 清除后端接口授权返回的数据
    public func removeApiData() {
        UserDefaults.standard.removeObject(forKey: self.KEY_API_ACCESS_TOKEN)
        UserDefaults.standard.removeObject(forKey: self.KEY_API_REFRESH_TOKEN)
        UserDefaults.standard.removeObject(forKey: self.KEY_API_LOGIN_USER_ID)
        UserDefaults.standard.removeObject(forKey: self.KEY_API_CREATE_TIME)
    }
    
    let KEY_WECHAT_ACCESS_TOKEN = "wechat_access_token"
    let KEY_WECHAT_REFRESH_TOKEN = "wechat_refresh_token"
    let KEY_WECHAT_OPENID = "wechat_openid"
    let KEY_WECHAT_UNIONID = "wechat_unionid"
    let KEY_WECHAT_EXPIRES_IN = "wechat_expires_in"
    let KEY_WECHAT_CREATE_TIME = "wechat_create_time"
    
    // MARK: 设置微信授权获取的数据
    public func setWechatData(access_token: String, refresh_token: String, openid: String, unionid: String?, expires_in: Int?) {
        UserDefaults.standard.set(access_token, forKey: self.KEY_WECHAT_ACCESS_TOKEN)
        UserDefaults.standard.set(refresh_token, forKey: self.KEY_WECHAT_REFRESH_TOKEN)
        UserDefaults.standard.set(openid, forKey: self.KEY_WECHAT_OPENID)
        
        if (unionid != nil) {
            UserDefaults.standard.set(unionid!, forKey: self.KEY_WECHAT_UNIONID)
        }
        
        if (expires_in != nil) {
            UserDefaults.standard.set(expires_in, forKey: self.KEY_WECHAT_EXPIRES_IN)
        }
        
        if (unionid != nil && expires_in != nil) {
            UserDefaults.standard.set(Date(), forKey: self.KEY_WECHAT_CREATE_TIME)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 获取微信授权获取的数据
    public func getWechatData(key: String?) -> Any {
        if (key != nil) {
            return self.getStringWithDefault(key: key!)
        } else {
            return [
                "access_token": self.getStringWithDefault(key: self.KEY_WECHAT_ACCESS_TOKEN),
                "refresh_token": self.getStringWithDefault(key: self.KEY_WECHAT_REFRESH_TOKEN),
                "openid": self.getStringWithDefault(key: self.KEY_WECHAT_OPENID),
                "unionid": self.getStringWithDefault(key: self.KEY_WECHAT_UNIONID),
                "expires_in": self.getStringWithDefault(key: self.KEY_WECHAT_EXPIRES_IN),
                "create_time": self.getStringWithDefault(key: self.KEY_WECHAT_CREATE_TIME),
            ]
        }
    }
    
    // MARK: 清除微信授权获取的数据
    public func removeWechatData() {
        UserDefaults.standard.removeObject(forKey: self.KEY_WECHAT_ACCESS_TOKEN)
        UserDefaults.standard.removeObject(forKey: self.KEY_WECHAT_REFRESH_TOKEN)
        UserDefaults.standard.removeObject(forKey: self.KEY_WECHAT_OPENID)
        UserDefaults.standard.removeObject(forKey: self.KEY_WECHAT_UNIONID)
        UserDefaults.standard.removeObject(forKey: self.KEY_WECHAT_EXPIRES_IN)
        UserDefaults.standard.removeObject(forKey: self.KEY_WECHAT_CREATE_TIME)
        UserDefaults.standard.synchronize()
    }
}
