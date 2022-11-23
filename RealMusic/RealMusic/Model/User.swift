
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable, Encodable {
    
    @DocumentID var id : String?
    var username: String
    var profilePic: String?
    var friends: [User]?// look into this
    var matchScore: Double?
    
    
}
 
