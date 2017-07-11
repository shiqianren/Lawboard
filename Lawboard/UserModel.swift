import Foundation

struct UserModel {
    var id: Int64
    var name: String
    var image: String
    var token: String
    
    init(id: Int64, name: String, image: String, token: String) {
        self.id = id
        self.name = name
        self.image = image
        self.token = token
    }
    
    func toArray() -> [String:Any] {
        return [
            "id": self.id,
            "name": self.name,
            "image": self.image,
            "token": self.token
        ]
    }
}
