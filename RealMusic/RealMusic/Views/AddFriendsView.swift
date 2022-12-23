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

        VStack {
            
            Button {
                withAnimation {
                    friendsToggle.toggle()
                }
            } label: {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        
            
            
            Spacer()
            
            Text("Add friends")
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("Grey 1"))
                TextField("", text: $username)
                    .placeholder(when: username.isEmpty) {
                           Text("Search for a user ..").foregroundColor(Color("Grey 1"))
                   }
                

            }
            .padding(10)
            .frame(height: 40)
            .background(.white)
            .cornerRadius(13)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .foregroundColor(.black)

            Text(errorMessage)
                .foregroundColor(.red)
            Text("Add Friend")
                .padding(5)
                .frame(width: 120)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(20)
                .fontWeight(.bold)
                .padding(.bottom, 20)
                .onTapGesture {
                    userViewModel.fetchUsers() { users in
                        self.nameFound = false
                        self.errorMessage = ""
                        print("print usernames")
                        for user in users {
                            print(user.username)
                            if username == user.username {
                                self.nameFound = true
                                let foundUser = user
                                userViewModel.addFriend(friend: foundUser)
                                friendsViewModel.fetchFriends()
                                analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
                                username = ""
                            }
                        }
                        if self.nameFound == false {
                            self.errorMessage = "User not found"
                        }
                    }
                }

            
            VStack {
                HStack {
                    Text("Your Friends")
                        .foregroundColor(.white)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("Music Taste")
                        .foregroundColor(.white)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                ScrollView {
                    ForEach(friendsViewModel.friends.sorted(by: { $0.matchScore ?? 0 > $1.matchScore ?? 0 })) { friend in
                        HStack {
                            if let url = URL(string: friend.profilePic ?? "") {
                                CacheAsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                        
                                    case .failure(let error):
                                        //                    //print(error)
                                        Rectangle()
                                            .background(.green)
                                            .foregroundColor(.black)
                                            .frame(width: 100, height: 110)
                                    case .empty:
                                        // preview loader
                                        Rectangle()
                                            .background(.green)
                                            .foregroundColor(.black)
                                            .frame(width: 100, height: 110)

                                    }
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(30)
                            }
                           
//                            .onAppear(perform: {
//                                userViewModel.fetchProfilePic(uid: friend.id!) { profile in
//                                    print("profilepic is \(profile)")
//                                }
//                            })


                            VStack {
                                Text(friend.username)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(5)
                                    .foregroundColor(Color("Grey"))
                            }
                            
                            Text(String(friend.matchScore ?? 0))
                                .foregroundColor(.white)

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
        .onAppear( perform: {
            // run function to calculate all scores
            print("showing add friends view")
            analyticsModel.fetchTopArtistsFromAPI() { (result) in
                switch result {
                case .success(let data):
                    analyticsModel.uploadToDB(items: data, rankingType: "Top Artists")
                    analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
                    friendsViewModel.fetchFriends()
                case .failure(let error):
                    print(error)
                }
            }
            
        })
            
            
            
                
        
       
        

    }
    
    struct AddFriends_Previews: PreviewProvider {
        @State static var toggle = false
        static var previews: some View {
            AddFriendsView(userViewModel: UserViewModel(),friendsViewModel: FriendsViewModel(),  friendsToggle: $toggle)

        }
    }
}
