//
//  FriendsViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 14/11/2022.
//

import Foundation

class FriendsViewModel: ObservableObject {
    @Published var friends = [User]()
    @Published var friendsNames = [String]()

    init() {
        fetchFriends()
    }

    // Fetches every post and user who made the post
    func fetchFriends() {
        friendsNames = []
        friends = []
        let userViewModel = UserViewModel()
        let uid = UserDefaults.standard.value(forKey: "uid")
        if uid != nil {
            userViewModel.fetchFriends(withId: uid as! String) { user in
                self.friends = user
                for friend in user {
                    self.friendsNames.append(friend.username)
                }
            }
        }
    }
}
