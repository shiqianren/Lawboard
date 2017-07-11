
import Foundation

/// User操作类
///
///     LawboardUser.shareInstance
///
class LawboardUser  {
    /// 单例
    static var shareInstance = LawboardUser()
    
    /// 登陆后信息存储在UserDefaults中的key名
    private let loginUserKeyName = "login_user"
    
    /// 代理
    open weak var delegate: LawboardUserDelegate?
    
    /// HTTP请求类单例
    open var api: LawBoardApi
    
    /// 构造函数
    private init() {
        self.api = LawBoardApi.shareInstance
    }
    
    // MARK: 获取登录后得到的Token
    /// 获取登录后得到的Token
    ///
    ///     let token = LawboardUser.shareInstance.getToken()
    ///
    /// - Returns: Token字符串
    open func getToken() -> String {
        let user = self.getUser()
        
        if (user != nil) {
            return user!.token
        } else {
            return ""
        }
    }
    
    // MARK: 获取登录后的用户
    /// 获取登录后的用户
    ///
    ///     let user = LawboardUser.shareInstance.getUser()
    ///
    /// - Returns: UserModel类实例
    open func getUser() -> UserModel? {
        let userArray = UserDefaults.standard.dictionary(forKey: self.loginUserKeyName)
        
        if userArray != nil {
            return UserModel(id: userArray!["id"] as! Int64, name: userArray!["name"] as! String, image: userArray!["image"] as! String, token: userArray!["token"] as! String)
        } else {
            return nil
        }
    }
    
    // MARK: 设置本地兴趣数据
    /// 设置本地兴趣数据
    ///
    ///     LawboardUser.shareInstance.setInterestIds(interestIds: [1,2,3])
    ///
    /// - Parameters:
    ///     - interestIds: 兴趣ID数组
    open func setInterestIds(interestIds: [Int]) {
        UserDefaults.standard.set(interestIds, forKey: "interest_ids")
    }
    
    // MARK: 获取本地兴趣数据
    /// 获取本地兴趣数据
    ///
    ///     let ids = LawboardUser.shareInstance.getInterestIds()
    ///
    /// - Returns: 兴趣ID数组
    open func getInterestIds() -> [Int]? {
        return UserDefaults.standard.array(forKey: "interest_ids") as? [Int]
    }
}
