import Foundation
import UIKit

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

class LawBoardUtil {
    /// MARK: 返回设备的像素比例
    static func getDeviceScale() -> Int {
        switch UIDevice().modelName {
        case "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus (CDMA)", "iPhone 7 Plus (GSM)":
            return 3
        case "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7 (CDMA)", "iPhone 7 (GSM)":
            return 2
        default:
            return 1
        }
    }
    
    /// MARK: 判断是否为ipad
    static func isPad() -> Bool {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            return true
        }
        
        switch UIDevice().modelName {
        case "iPad 2", "iPad 3", "iPad 4", "iPad Air", "iPad Air 2", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4", "iPad Pro":
            return true
        default:
            return false
        }
    }
    
    /// MARK: 获取sd_setImage所需图片路径
    static func getImageUrl(filename: String) -> String {
        switch UIDevice().modelName {
            case "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus (CDMA)", "iPhone 7 Plus (GSM)":
                return "\(HTTP_API_HOST)/images/\(filename)@3x.png"
            case "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7 (CDMA)", "iPhone 7 (GSM)":
                return "\(HTTP_API_HOST)/images/\(filename)@2x.png"
            default:
                return "\(HTTP_API_HOST)/images/\(filename)@1x.png"
        }
    }
    
    static func getImageUrl(filename: String, scale: Int) -> String {
        return "\(HTTP_API_HOST)/images/\(filename)@\(scale)x.png"
    }
	
	/// MARK: 获取sd_setImage所需图片路径
	static func getwenTanImageUrl(filename: String) -> String {
		switch UIDevice().modelName {
		case "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus (CDMA)", "iPhone 7 Plus (GSM)":
			return "\(HTTP_API_HOST)/uploadimages/\(filename)@3x.png"
		case "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7 (CDMA)", "iPhone 7 (GSM)":
			return "\(HTTP_API_HOST)/uploadimages/\(filename)@2x.png"
		default:
			return "\(HTTP_API_HOST)/uploadimages/\(filename)@1x.png"
		}
	}
	
    /// MARK: 格式化HTML字符串到attributeText所需字符串
    static func stringFromHtml(string: String) -> NSAttributedString? {
        do{
            return try NSAttributedString(data: (string.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// MARK: 获取webView访问URL
    static func getUrl(shortUrl: String) -> String {
        return "\(HTTP_API_HOST)/site\(shortUrl)"
    }
    
    
    /// MARK: 获取签名
    static func getSignature() {
        
    }
}
