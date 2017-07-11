import Foundation

enum MODE_TYPE {
    case dev
    case devonline
    case online
}
/// 项目模式：dev-本地开发，devonline-线上测试环境，online-线上
let MODE:MODE_TYPE = .online
let VERSION = "1.1"

func getHost() -> String {
    switch MODE {
    case .dev:
        return "http://102.168.31.136:8080"
    case .devonline:
		return ""
    case .online:
		return ""
    }
}


/// 后端地址：
/// http://101.37.12.237
/// http://192.168.31.181:8080
let HTTP_API_HOST = getHost()

let WECHAT_API_STATE_USERLOGIN = "HelloBoardUserLogin"
let WECHAT_API_STATE_USERBIND = "HelloBoardUserBind"

let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height
let SCALE = UIScreen.main.scale

let NORMAL_BTN_HEIGHT = LawBoardUtil.isPad() ? 12 * SCALE : 20 * SCALE
let NORMAL_BTN_RADIUS = LawBoardUtil.isPad() ? 6 * SCALE : 10 * SCALE

let TOP_SPACE = 5 * SCALE
