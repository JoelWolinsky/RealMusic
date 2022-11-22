
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable, Encodable {
    
    @DocumentID var id : String?
    var username: String
    var profilePic: URL?
    var friends: [User]? // look into this
    
    
}
 
