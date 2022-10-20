
import FirebaseFirestoreSwift

struct Post: Identifiable, Decodable, Encodable {
    
    @DocumentID var id: String?
    var songID: String
    var title: String?
    var uid: String
    var username : String?
    var cover : String?
}
