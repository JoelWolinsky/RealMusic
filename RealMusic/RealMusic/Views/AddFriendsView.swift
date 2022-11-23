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
    @ObservedObject var analyticsModel = AnalyticsModel()
    @ObservedObject var friendsViewModel = FriendsViewModel()


    
    @State var nameFound = false
    @State var errorMessage = ""
    
    @State var username = ""
    
    
    //@StateObject var feedViewModel: FeedViewModel
    
    @Binding var friendsToggle: Bool
    @State var profilePic = URL(string: "")
    
    @State var showCompareAnalytics = false
    @State var friendToCompare =  User(username: "")
    
    @State var yourUID = (UserDefaults.standard.value(forKey: "uid") ?? "") as! String

    

    
    
    var body: some View {
        ZStack {
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
                    .foregroundColor(.red)
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
                                    let foundUser = user
                                    userViewModel.addFriend(friend: foundUser)
                                }
                            }
                            if self.nameFound == false {
                                self.errorMessage = "User not found"
                            }
                        }
                    }
                
                VStack {
                    
                    Text("Your Friends")
                        .foregroundColor(.white)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView {
                        ForEach(friendsViewModel.friends.sorted(by: { $0.matchScore ?? 0 > $1.matchScore ?? 0 })) { friend in
                            HStack {
                                
                                AsyncImage(url: URL(string: friend.profilePic ?? "no profile pic")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    
                                } placeholder: {
                                    Color.orange
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(30)
                                .onAppear(perform: {
                                    userViewModel.fetchProfilePic(uid: friend.id!) { profile in
                                        print(profile)
                                        //friend = User(username: friend.username, profilePic: profile)
                                    }
                                })
    

                                VStack {
                                    Text(friend.username)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(5)
                                    //.background(.green)
                                        .foregroundColor(Color("Grey"))
//                                        .onTapGesture {
//                                            showCompareAnalytics.toggle()
//                                            friendToCompare = friend
//                                        }
                                    Text(friend.id ?? "")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(5)
                                    //.background(.green)
                                        .foregroundColor(Color("Grey"))
                                }
                                
                                Text(String(friend.matchScore ?? 0))
                                    .foregroundColor(.purple)
                                
//                                CompareAnalyticsView(friendUID: friend.id ?? "ID placeholder")
//                                    .onAppear(perform: {
//                                        print("showing score")
//                                    })
                                    
                                    
                                   
                                    
                                        

                                
                            }
                            
                        }
                    }
                    
                    .refreshable {
                        // run function to calculate all scores
                        await analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
                        friendsViewModel.fetchFriends()
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(20)
            .background(.black)

            
            
                
        }
        .onAppear( perform: {
            // run function to calculate all scores
            print("showing add friends view")
            analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
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
