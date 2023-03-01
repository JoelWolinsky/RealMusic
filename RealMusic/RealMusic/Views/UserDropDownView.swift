//
//  UserDropDownView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 15/02/2023.
//

import Foundation
import SwiftUI

struct UserDropDownView : View {
    
    @State private var animatePicker2 = false
    
    var username: String
    
    @StateObject var spotifyAPI: SpotifyAPI
    
    @Binding var showPicker: Bool
    @Binding var longPress: Int
    @Binding var blur: Int
    @Binding var disableScroll: Int
    
    @Binding var showUserDropDown: Bool
    
    @StateObject var userViewModel: UserViewModel
    
    @State var following: Bool
    
    
    var body: some View {
        VStack{
            ZStack{
                VStack(spacing: 0) {
                    if !following {
                        Button(action: {
                            
                            userViewModel.fetchUsers() { users in
                                print("print usernames")
                                for user in users {
                                    print(user.username)
                                    if username == user.username {
                                        let foundUser = user
                                        userViewModel.addFriend(friend: foundUser)
                                        //friendsViewModel.fetchFriends()
                                        //analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
                                    }
                                }
                            }
                            
                            
                            withAnimation(.easeIn(duration: 0.2)) {
                                showPicker = false
                                longPress = 0
                                blur = 0
                                disableScroll = 1000
                                showUserDropDown = false
                            }
                            
                        }, label: {
                            HStack {
                                Text("Follow user")
                                    .foregroundColor(.white)
                                Spacer ()
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: animatePicker2 ? 20 : 0))
                            }
                            .frame(maxHeight: animatePicker2 ? 10 : 0, alignment: .center)
                            .padding(20)
                            
                        })
                        .buttonStyle(DropDownButton())
                    } else {
                        Button(action: {
                            
                            userViewModel.fetchUsers() { users in
                                print("print usernames")
                                for user in users {
                                    print(user.username)
                                    if username == user.username {
                                        let foundUser = user
                                        userViewModel.removeFriend(friend: foundUser)
                                        //friendsViewModel.fetchFriends()
                                        //analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
                                    }
                                }
                            }
                            
                            
                            withAnimation(.easeIn(duration: 0.2)) {
                                showPicker = false
                                longPress = 0
                                blur = 0
                                disableScroll = 1000
                                showUserDropDown = false
                            }
                            
                        }, label: {
                            HStack {
                                Text("Unfollow user")
                                    .foregroundColor(.white)
                                Spacer ()
                                Image(systemName: "minus")
                                    .foregroundColor(.white)
                                    .font(.system(size: animatePicker2 ? 20 : 0))
                            }
                            .frame(maxHeight: animatePicker2 ? 10 : 0, alignment: .center)
                            .padding(20)
                            
                        })
                        .buttonStyle(DropDownButton())
                    }
                }
                
                VStack {
//                    Spacer()
//                    Rectangle()
//                        .foregroundColor(Color("Grey 1"))
//                        .frame(maxWidth: .infinity, maxHeight: 1)
//                    Spacer()
//                    Rectangle()
//                        .foregroundColor(Color("Grey 1"))
//                        .frame(maxWidth: .infinity, maxHeight: 1)
//                    Spacer()
//                    Rectangle()
//                        .foregroundColor(Color("Grey 1"))
//                        .frame(maxWidth: .infinity, maxHeight: 1)
//                    Spacer()
                    
                }
            }
            .frame(maxWidth: animatePicker2 ? 250 : 0, maxHeight: animatePicker2 ? 50 : 0)
            //.background(Color("Grey 2"))
            .background(.regularMaterial)
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.35, dampingFraction: 1, blendDuration: 0)) {
                animatePicker2 = true
            }
        })

    }
    
//    struct PostDropDownView_Previews: PreviewProvider {
//        static var previews: some View {
//            PostDropDownView(spotifyAPI: SpotifyAPI())
//
//        }
//    }
}


struct UserDownButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color("Grey 1") : .clear)
            


    }
}
