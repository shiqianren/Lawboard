
import Foundation

struct NewsDataModel {
    var newId: Int64
    var mediaImage: String
    var mediaId: Int
    var mediaName: String
    var mediaLink: String
    var timeGap: String
    var newTitle: String
    var newSummary: String
    var collectInfo: String
    
    init(data: [String:Any]) {
        self.newId = data["id"] as! Int64
        self.mediaImage = ""
        self.mediaId = data["user_id"] as! Int
        self.mediaName = data["user_name"] as! String
        self.mediaLink = data["user_name"] as! String
        self.timeGap = data["create_time"] as! String
        self.newTitle = data["title"] as! String
        self.newSummary = data["content"] as! String
        
        let approveCount = data["approve_count"] as! Int
        let followCount = data["follow_count"] as! Int
        
        self.collectInfo = ""
        
        if approveCount > 0 {
            self.collectInfo += "\(approveCount)个赞"
        }
        
        if approveCount > 0 && followCount > 0 {
            self.collectInfo += "·"
        }
        
        if followCount > 0 {
            self.collectInfo += "被收集了\(followCount)次"
        }
    }
}
