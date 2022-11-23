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
        postView.fetchData { posts in
            self.posts = posts
            
            self.posts = self.posts.sorted(by: { $0.datePosted > $1.datePosted })
            print(posts.count)
            for i in 0 ..< posts.count {
                let uid = posts[i].uid
                userView.fetchUser(withId: uid) { user in
                    self.posts[i].username = user.username
                    print(user.username)
                }
            }
        }
    }
    
    func fetchReactions() {
        print("Fetch reactions")
        var emojis = [Emoji]()
        let db = Firestore.firestore()
        
        var counter = 0
     
        for post in self.posts {
            db.collection("Posts")
                .document(post.id!)
                .collection("Reactions")
                .getDocuments() { (querySnapshot, err) in
                    emojis = []
                    guard let documents = querySnapshot?.documents else { return }
                    documents.forEach{ emoji in
                        guard let emoji = try? emoji.data(as: Emoji.self) else { return }
                        
                        emojis.append(emoji)
                        print("append \(emoji.name)")
                    }
                    self.posts[counter].reactions = emojis
                    counter += 1
                    
                }
        }
    }
}
