
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable, Encodable {
    
    @DocumentID var id : String?
    var username: String
    var friends: [User]? // look into this
    
}
 
