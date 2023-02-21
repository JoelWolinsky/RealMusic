////
////  FriendView.swift
////  RealMusic
////
////  Created by Joel Wolinsky on 20/02/2023.
////
//
//import Foundation
//import SwiftUI
//
//struct AddFriendsView: View {
//    
//    @ObservedObject var userViewModel = UserViewModel()
//    @ObservedObject var analyticsModel = AnalyticsModel()
//    @ObservedObject var friendsViewModel = FriendsViewModel()
//    
//    @State var friend: User
//
//
//    
//    @State var nameFound = false
//    @State var errorMessage = ""
//    
//    @State var username = ""
//    
//    
//    //@StateObject var feedViewModel: FeedViewModel
//    
//    @Binding var friendsToggle: Bool
//    @State var profilePic = URL(string: "")
//    
//    @State var showCompareAnalytics = false
//    @State var friendToCompare =  User(username: "")
//    
//    @State var yourUID = (UserDefaults.standard.value(forKey: "uid") ?? "") as! String
//    
//    
//
//    
//
//    
//    
//    var body: some View {
//
//        HStack {
//            if let url = URL(string: ((friend.id ?? "") + ".heic") ?? "") {
//                CacheAsyncImage(url: url) { phase in
//                    switch phase {
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                        
//                    case .failure(let error):
//                        Rectangle()
//                            .background(.black)
//                            .foregroundColor(.black)
//                            .frame(width: 100, height: 110)
//                    case .empty:
//                        Rectangle()
//                            .background(.black)
//                            .foregroundColor(.black)
//                            .frame(width: 100, height: 110)
//
//                    }
//                }
//                .frame(width: 60, height: 60)
//                .cornerRadius(30)
//            }
//           
////                            .onAppear(perform: {
////                                userViewModel.fetchProfilePic(uid: friend.id!) { profile in
////                                    print("profilepic is \(profile)")
////                                }
////                            })
//
//
//            VStack {
//                Text(friend.username)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(5)
//                    .foregroundColor(Color("Grey"))
//            }
//            
//            Text(String(friend.matchScore ?? 0))
//                .foregroundColor(.white)
//
//        }
//        .padding(20)
//        .background(.black)
////        .onAppear( perform: {
////            // run function to calculate all scores
////            print("showing add friends view")
////            analyticsModel.fetchTopArtistsFromAPI() { (result) in
////                switch result {
////                case .success(let data):
////                    analyticsModel.uploadToDB(items: data, rankingType: "Top Artists")
////                    analyticsModel.compareForEach(yourUID: yourUID, friends: friendsViewModel.friends)
////                    friendsViewModel.fetchFriends()
////                case .failure(let error):
////                    print(error)
////                }
////            }
////
////        })
//            
//            
//            
//                
//        
//       
//        
//
//    }
//    
//    struct AddFriends_Previews: PreviewProvider {
//        @State static var toggle = false
//        static var previews: some View {
//            AddFriendsView(userViewModel: UserViewModel(),friendsViewModel: FriendsViewModel(),  friendsToggle: $toggle)
//
//        }
//    }
//}
