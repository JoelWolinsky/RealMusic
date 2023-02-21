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
    @Published var myPosts = [Post]()

//    @Published var postReactions = [Reactions]
//    let postView = PostViewModel()
//    let userView = UserViewModel()

    init() {
        //fetchPosts()
        //fetchMyPosts()
        //print("fetching")
    }
    
    // Fetches every post and user who made the post
    func fetchPosts() {
        //self.posts = []
        let postView = PostViewModel()
        let userView = UserViewModel()
        posts = []
        postView.fetchData { posts in
            
            for post in posts {
                
                if post.datePosted.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted) {
                    print("this is a post UID \(post.uid)")
                    if UserDefaults.standard.value(forKey: "uid") != nil {
                        if post.uid == UserDefaults.standard.value(forKey: "uid") as! String {
                            self.myPosts.append(post)
                            
                        } else {
                            self.posts.append(post)
                            
                        }
                    }
                    print("todays post: \(post.uid)")
                }
            }
            self.posts = self.posts.sorted(by: { $0.datePosted > $1.datePosted })
        }
    }
    
    // Fetches every post and user who made the post
    func fetchMyPosts() {
        self.myPosts = []
        let postView = PostViewModel()
        let userView = UserViewModel()
        postView.fetchData { posts in
            for post in posts {
                print("this is my uid \(UserDefaults.standard.value(forKey: "uid"))")
                if post.datePosted.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted) {
                    
//                    if post.uid == UserDefaults.standard.value(forKey: "uid") as! String {
//                        self.myPosts.append(post)
//                    }
                }
                if post.uid == UserDefaults.standard.value(forKey: "uid") as! String {
                    self.myPosts.append(post)
                }
            }
            self.myPosts = self.myPosts.sorted(by: { $0.datePosted > $1.datePosted })
        }
    }
    
    func fetchReactions(postUID: String, completion: @escaping([Emoji]) -> Void) {
        var emojis = [Emoji]()
        let db = Firestore.firestore()
        
        db.collection("Posts")
            .document(postUID)
            .collection("Reactions")
            .getDocuments() { (querySnapshot, err) in
                //emojis = []
                guard let documents = querySnapshot?.documents else { return }
                documents.forEach { emoji in
                    guard let emoji = try? emoji.data(as: Emoji.self) else { return }
                    emojis.append(emoji)
                }
                completion(emojis)
            }
    }
    
    func addLocalReaction(postID: String, emoji: Emoji) {
        
    }
}
