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
//            for i in 0 ..< posts.count {
//                print("i \(i)")
//                let uid = posts[i].id!
//                userView.fetchUser(withId: uid) { user in
//                    self.posts[i].username = user.username
//                    print("username is \(user.username)")
//                }
//            }
            var counter = 1000
            for post in posts {
                //counter += 1
                //let uid = posts[x].id!
                //print(posts[x].id)
                //let post = posts[x]
                print("post title \(post.title)")
                print("post id \(post.id)")
                print("post date \(post.datePosted)")
                self.fetchReactions(postUID: post.id ?? "") { reactions in
                    counter += 1
                    //let counter = x
                    //print("temp \(reactions.count) \(post.id) for \(counter) \(post.title) ")
                    print("reactions for post \(reactions.count) for \(post.title) \(post.datePosted) \(String(counter)) \(post.id)")
                    if reactions.count != 0 {
                        
                        self.posts.removeAll { reactedPost in
                            print("removing \(post.id)")
                            return reactedPost.id == post.id //&& post.reactions == nil
                        }
                        self.posts.append(  Post(id: post.id,
                                                 songID: post.songID,
                                                 title: post.title,
                                                 artist: post.artist,
                                                 uid: post.uid,
                                                 username: post.username,
                                                 cover: post.cover,
                                                 datePosted: post.datePosted,
                                                 preview: post.preview,
                                                 reactions: reactions
                                                ))
                        self.posts = self.posts.sorted(by: { $0.datePosted > $1.datePosted })

                    }
                   // print("reactions is this \(reactions.count) for \(self.posts[counter].id) post length \(self.posts.count)")
                    
                }
            }
            //self.posts = self.posts.sorted(by: { $0.datePosted > $1.datePosted })

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
}
