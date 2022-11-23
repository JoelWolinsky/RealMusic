
import FirebaseFirestore

class PostViewModel: ObservableObject {
    
    // Fetch post data from Firebase 
    func fetchData(completion: @escaping([Post]) -> Void ) {
        var posts = [Post]()
        let db = Firestore.firestore()

        db.collection("Posts")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else { print("no document"); return }
                documents.forEach{ post in
                    guard let post = try? post.data(as: Post.self) else { print("no posts"); return }
                    posts.append(post)
                }
                completion(posts)
            }
    }
    
   
    
    
  
    

}
