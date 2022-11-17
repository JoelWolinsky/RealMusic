//
//  AddFriends.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 13/11/2022.
//

import Foundation
import SwiftUI

struct AddFriendsView: View {
    
    @ObservedObject var userViewModel = UserViewModel()
    
    @State var nameFound = false
    @State var errorMessage = ""
    
    @State var username = ""
    
    @ObservedObject var friendsViewModel = FriendsViewModel()
    
    //@StateObject var feedViewModel: FeedViewModel
    
    @Binding var friendsToggle: Bool

    
    
    var body: some View {

        VStack {
            
            Button {
                withAnimation {
                    friendsToggle.toggle()
                }
            } label: {
                Text("Back")
                    .foregroundColor(.green)
                    .font(.system(size:20))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            VStack {
                Text("Username: " + (UserDefaults.standard.value(forKey: "Username") as? String ?? ""))
                Text("UID: " + (UserDefaults.standard.value(forKey: "uid") as? String ?? ""))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .padding(.bottom, 30)
            
            
            
            Spacer()
            
            Text("Add friends")
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a user ..", text: $username)
            }
            .padding(10)
            .frame(height: 40)
            .background(.green)
            .cornerRadius(13)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            
            Text(errorMessage)
            Text("Add Friend")
                .padding(5)
                .frame(width: 120)
                .background(.green)
                .cornerRadius(20)
                .fontWeight(.bold)
                .padding(.bottom, 20)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView {
                    ForEach(friendsViewModel.friends) { friend in
                        HStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 60)
                            Text(friend.username)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                                //.background(.green)
                                .foregroundColor(Color("Grey"))
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding(20)
        .background(.black)
        .onAppear(perform: {
            print("AddFriends View")
            friendsViewModel.fetchFriends()
        })
        
        

    }
    
    struct AddFriends_Previews: PreviewProvider {
        @State static var toggle = false
        static var previews: some View {
            AddFriendsView(userViewModel: UserViewModel(),friendsViewModel: FriendsViewModel(),  friendsToggle: $toggle)

        }
    }
}
