//
//  AddFriends.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 13/11/2022.
//

import Foundation
import SwiftUI

struct AddFriends: View {
    
    @ObservedObject var userViewModel = UserViewModel()
    
    @State var nameFound = false
    @State var errorMessage = ""
    
    @State var username = ""
    
    @ObservedObject var friendsViewModel = FriendsViewModel()
    
    
    var body: some View {
        VStack {
            VStack {
                Text("Username: " + (UserDefaults.standard.value(forKey: "Username") as? String ?? ""))
                Text("UID: " + (UserDefaults.standard.value(forKey: "uid") as? String ?? ""))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            Spacer()
            
            Text("Add friends")
            TextField("Username", text: $username)
                .background(.white)
                .cornerRadius(3)
            Text(errorMessage)
            Text("Add Friend")
                .padding(5)
                .background(.green)
                .onTapGesture {
                    userViewModel.fetchUsers() { users in
                        self.nameFound = false
                        self.errorMessage = ""
                        //print(user.username)
                        //UserDefaults.standard.setValue(user.username, forKey: "Username")
                        print("print usernames")
                        for user in users {
                            print(user.username)
                            if username == user.username {
                                self.nameFound = true
                                self.errorMessage = "Username is taken"
                                let foundUser = user
                                userViewModel.addFriend(friend: foundUser)
                            }
                        }
                    }
                }
            
            VStack{
                
                Text("Your Friends")
                    .foregroundColor(.white)
                    .padding(5)

                ForEach(friendsViewModel.friends) { friend in
                    Text(friend.username)
                        .padding(5)
                        .background(.green)
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .background(Color("Grey 3"))
            .padding(20)
            
            Spacer()
        }
        .padding(20)
        .onAppear(perform: {
            friendsViewModel.fetchFriends()
        })
    }
    
    struct AddFriends_Previews: PreviewProvider {
        static var previews: some View {
            AddFriends()
            
        }
    }
}
