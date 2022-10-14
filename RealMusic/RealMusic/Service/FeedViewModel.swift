//
//  FeedViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    let postView = PostViewModel()
    let userView = UserViewModel()
    
    init() {
        fetchPosts()
        print("fetching")
    }
    
    func fetchPosts() {
        postView.fetchData { posts in
            self.posts = posts
            print(posts.count)
            for i in 0 ..< posts.count {
                let uid = posts[i].uid
                self.userView.fetchUser(withId: uid) { user in
                    self.posts[i].username = user.username
                    print(user.username)
                }
            }
        }
    }
}
