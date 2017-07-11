
import Foundation

// MARK: 后端请求接口类的代理
@objc protocol LawBoardApiDelegate: class {
    func apiRequestError(msg: String)
    @objc optional func getNewListFailure(msg: String)
    @objc optional func getNewItemFailure(msg: String)
    @objc optional func getInterestListFailure(msg: String)
}
