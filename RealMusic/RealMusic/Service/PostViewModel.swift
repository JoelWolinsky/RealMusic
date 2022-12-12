
import FirebaseFirestore

class PostViewModel: ObservableObject {
    
    // Fetch post data from Firebase 
    func fetchData(completion: @escaping([Post]) -> Void ) {
        var posts = [Post]()
        let db = Firestore.firestore()
        
        var emojis = [Emoji]()
        var postNumber = 0
        db.collection("Posts")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else { print("no document"); return }
                documents.forEach{ post in
                    guard let post = try? post.data(as: Post.self) else { return }
                    if post.datePosted.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted) {
                        print("todays post: \(post.id)")
                        posts.append(post)
                    } 
                }
                completion(posts)
            }
    }
    
   
    
    
  
    

}
