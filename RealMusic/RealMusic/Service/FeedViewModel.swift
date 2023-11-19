//
//  FeedViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import FirebaseFirestore
import Foundation

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var myPosts = [Post]()
    @Published var todaysPost = [Post]()

    // Fetches every post and user who made the post
    func fetchPosts() {
        // self.posts = []
        let postView = PostViewModel()
        let userView = UserViewModel()
        posts = []
        todaysPost = []
        postView.fetchData { posts in
            for post in posts {
                if UserDefaults.standard.value(forKey: "uid") != nil {
                    if post.uid == UserDefaults.standard.value(forKey: "uid") as! String {
                        // self.todaysPost.append(post)

                    } else {
                        self.posts.append(post)
                    }
                }
            }
            self.posts = self.posts.sorted(by: { $0.datePosted > $1.datePosted })
        }
    }

    // Fetches every post and user who made the post
    func fetchMyPosts() {
        myPosts = []
        let postView = PostViewModel()
        let userView = UserViewModel()
        postView.fetchData { posts in
            for post in posts {
                if post.datePosted.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted) {
                    if post.uid == UserDefaults.standard.value(forKey: "uid") as! String {
                        self.todaysPost.append(post)
                    }
                }
                if post.uid == UserDefaults.standard.value(forKey: "uid") as! String {
                    self.myPosts.append(post)
                }
            }
            self.myPosts = self.myPosts.sorted(by: { $0.datePosted > $1.datePosted })
        }
    }

    func fetchReactions(postUID: String, completion: @escaping ([Emoji]) -> Void) {
        var emojis = [Emoji]()
        let db = Firestore.firestore()

        db.collection("Posts")
            .document(postUID)
            .collection("Reactions")
            .getDocuments { querySnapshot, _ in
                guard let documents = querySnapshot?.documents else { return }
                documents.forEach { emoji in
                    guard let emoji = try? emoji.data(as: Emoji.self) else { return }
                    emojis.append(emoji)
                }
                completion(emojis)
            }
    }
    
    func addLocalReaction(postID _: String, emoji _: Emoji) {}
}
