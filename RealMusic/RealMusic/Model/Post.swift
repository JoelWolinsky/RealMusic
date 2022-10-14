
import FirebaseFirestoreSwift

struct Post: Identifiable, Decodable {
    
    @DocumentID var id: String?
    var title: String
    var uid: String
    var username : String?
    var cover : String?
}
