
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    
    @DocumentID var id : String?
    var username: String
    
}
 
