
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
//                    if post.datePosted.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted) {
//                        print("todays post: \(post.id) \(post.songID)")
//                        print(Date().formatted(date: .long, time: .omitted))
//                        print(Date().formatted(date: .complete, time: .omitted))
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
//                        print(formatter.string(from: Date()))

                        
                        posts.append(post)
     //               } 
                }
                completion(posts)
                //December 13, 2022
                //Tuesday, 13 December 2022
                
                //13 Dec 2022 13:33:40



            }
    }
    
   
    
    
  
    

}
