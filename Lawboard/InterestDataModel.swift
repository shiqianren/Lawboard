
struct MediaListModel {
    var name: String
    var bgImageUrl: String
    
    init(model: [String:Any]) {
        self.name = model["name"] as! String
        self.bgImageUrl = model["image"] as! String
    }
}

struct InterestDataModel {
    var id: Int
    var name: String
    var bgImageUrl: String
    var bgColor: String
    var mediaModelList: [MediaListModel]
    var selected: Bool
    
    init(model: [String:Any], selected: Bool = false) {
        self.id = model["id"] as! Int
        self.name = model["name"] as! String
        self.bgImageUrl = model["image"] as! String
        self.bgColor = model["color"] as! String
        
        var list = [MediaListModel]()
        
        for item in model["medias"] as! [[String:String]] {
            list.append(MediaListModel(model: item))
        }
        
        self.mediaModelList = list
        self.selected = selected
    }
}
