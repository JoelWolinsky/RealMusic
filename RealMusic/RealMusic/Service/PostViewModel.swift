
import FirebaseFirestore

class PostViewModel: ObservableObject {
    // Fetch post data from Firebase
    func fetchData(completion: @escaping ([Post]) -> Void) {
        var posts = [Post]()
        let db = Firestore.firestore()
        var emojis = [Emoji]()
        var postNumber = 0
        db.collection("Posts")
            .getDocuments { querySnapshot, _ in
                guard let documents = querySnapshot?.documents else { print("no document"); return }
                documents.forEach { post in
                    guard let post = try? post.data(as: Post.self) else { return }
                    posts.append(post)
                }
                completion(posts)
            }
    }
}
