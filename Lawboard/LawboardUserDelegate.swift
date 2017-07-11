
import Foundation

@objc protocol LawboardUserDelegate: class {
    @objc optional func loginSuccess()
    @objc optional func loginFailure(msg: String)
    @objc optional func logoutSuccess()
    @objc optional func logoutFailure(msg: String)
}
