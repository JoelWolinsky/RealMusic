
import FirebaseFirestore

class PostViewModel: ObservableObject {
    
    // Fetch post data from Firebase 
    func fetchData(completion: @escaping([Post]) -> Void ) {
        var posts = [Post]()
        let db = Firestore.firestore()
        
        var emojis = [Emoji]()
        var postNumber = 0
        print("fetch data")
        db.collection("Posts")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else { print("no document"); return }
                documents.forEach{ post in
                    guard let post = try? post.data(as: Post.self) else { print("no posts"); return }
                    posts.append(post)
                    print("append post \(post.id)")

//                    emojis = []
//                    db.collection("Posts")
//                        .document(post.id!)
//                        .collection("Reactions")
//                        .getDocuments() { (querySnapshot, err) in
//                            print("Get reaction docs \(post.id!)")
//                            emojis = []
//                            guard let documents = querySnapshot?.documents else { return }
//                            documents.forEach{ emoji in
//                                guard let emoji = try? emoji.data(as: Emoji.self) else { return }
//
//                                emojis.append(emoji)
//                                print("append \(emoji.name)")
//                                print("append emoji to \(posts[postNumber].id)")
//
//                            }
//                            //print("append emoji to \(posts[postNumber].id)")
//                            let postToAdd = Post(songID: post.songID,
//                                                 title: post.title,
//                                                 artist: post.artist,
//                                                 uid: post.uid,
//                                                 username: post.username,
//                                                 cover: post.cover,
//                                                 preview: post.preview,
//                                                 reactions: emojis)
//                            posts.append(postToAdd)
////                            counter += 1
//                            //post.reactions = emojis
//                            //posts.append(post)
//
//
//                        }
                    
                    
                    //posts.append(post)
                }
                
                print("sending back \(posts.count)")
                completion(posts)
            }
    }
    
   
    
    
  
    

}
