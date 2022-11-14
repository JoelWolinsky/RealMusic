//
//  FriendsViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 14/11/2022.
//


import Foundation

class FriendsViewModel: ObservableObject {
    @Published var friends = [User]()
//    let postView = PostViewModel()
//    let userView = UserViewModel()
    
    init() {
        fetchFriends()
        print("fetching")
    }
    
    // Fetches every post and user who made the post
    func fetchFriends() {
        //self.posts = []
        print("fetching friends")
        let userViewModel = UserViewModel()
        
        let uid = UserDefaults.standard.value(forKey: "uid")
        userViewModel.fetchFriends(withId: uid as! String ) { user in
//            print(user.username)
            print(user.count)
            self.friends = user
            
        }
    }
}

