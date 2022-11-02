//
//  FeedViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import Foundation

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
}
