//
//  FeedViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import Foundation
import FirebaseFirestore

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
//    @Published var postReactions = [Reactions]
//    let postView = PostViewModel()
//    let userView = UserViewModel()
    
    init() {
        fetchPosts()
        print("fetching")
    }
    
    // Fetches every post and user who made the post
    func fetchPosts() {
        //self.posts = []
        let postView = PostViewModel()
        let userView = UserViewModel()
        //posts = []
        postView.fetchData { posts in
            self.posts = posts
            
            self.posts = self.posts.sorted(by: { $0.datePosted > $1.datePosted })
            print("post count \(posts.count)")
        }
        
    }
    
    func fetchReactions(postUID: String, completion: @escaping([Emoji]) -> Void) {
        print("Fetch reactions")
        print(self.posts.count)
        var emojis = [Emoji]()
        let db = Firestore.firestore()
        
    
        print("post for reaction")
        db.collection("Posts")
            .document(postUID)
            .collection("Reactions")
            .getDocuments() { (querySnapshot, err) in
                print("Get reaction docs")
                //emojis = []
                guard let documents = querySnapshot?.documents else { return }
                print("number of reactions \(postUID) \(documents.count)")
                documents.forEach { emoji in
                    guard let emoji = try? emoji.data(as: Emoji.self) else { return }
                    
                    emojis.append(emoji)
                    print("append emoji \(emoji.name) to \(postUID)")
                }
                
                completion(emojis)
                
            }
        
    }
    
    func addLocalReaction(postID: String, emoji: Emoji) {
        
    }
}
