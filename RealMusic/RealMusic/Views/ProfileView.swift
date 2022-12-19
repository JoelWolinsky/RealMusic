//
//  ProfileView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import Foundation
import SwiftUI
import WebKit

struct ProfileView: View {
    
    @StateObject var signInModel: SignInViewModel
    
    @State var profilePic: String
    
    @Binding var showProfileView: Bool
    
    @ObservedObject var analyticsModel = AnalyticsModel()
    
    @StateObject var feedViewModel: FeedViewModel
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]
    
    @ObservedObject var getDateModel = GetDateModel()
    
    @State var splitByDate: SplitByDate
    
    
    var body: some View {
        
        VStack {
            
            Button {
                withAnimation {
                    showProfileView.toggle()
                }
            } label: {
                Text("Back")
                    .foregroundColor(.white)
                    .font(.system(size:20))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text("Profile")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                AsyncImage(url: URL(string: profilePic)) { image in
                    image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          
                } placeholder: {
                    Color.black
                }
                .frame(width: 130, height: 130)
                .cornerRadius(80)
                .padding( 20)
                
                Text(UserDefaults.standard.value(forKey: "username") as! String)
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)
                
//                VStack {
//                    Text("UID: " + (UserDefaults.standard.value(forKey: "uid") as? String ?? ""))
//                        .foregroundColor(Color("Grey"))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.bottom, 10)
//                }
                VStack {
                    Text("Memories")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 25))
                    ScrollView {
                        VStack {
                            ForEach(splitByDate.sections) { section in
                                VStack {
                                    Text("\(getDateModel.getMonthYear(datePosted: section.date))")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    LazyVGrid(columns: gridItemLayout) {
                                        ForEach(section.occurrences) { post in
                                            ZStack {
                                                if let url = URL(string: post.cover ?? "") {
                                                    CacheAsyncImage(url: url) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .cornerRadius(1)
                                                                .padding(.bottom, 5)
                                                            
                                                        case .failure(let error):
                                                            //                    //print(error)
                                                            Text("fail")
                                                        case .empty:
                                                            // preview loader
                                                            Rectangle()
                                                                .scaledToFill()
                                                                .cornerRadius(1)
                                                                .padding(.bottom, 5)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                }
                                                Text("\(getDateModel.getDay(datePosted: post.datePosted))")
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            //
                            //                        ForEach(feedViewModel.myPosts) { post in
                            //                            ZStack {
                            //                                VStack {
                            //
                            ////                                    Text("\(getDateModel.getDay(datePosted: post.datePosted))")
                            ////                                        .foregroundColor(.white)
                            ////                                    Text("\(getDateModel.getMonth(datePosted: post.datePosted))")
                            ////                                        .foregroundColor(.white)
                            //                                }
                            ////                                post.datePosted
                            ////                                formatter.string(from: post.datePosted)
                            ////                                let formatter = DateFormatter()
                            ////                                formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                            ////                                print(formatter.string(from: Date()))
                            //                            }
                            //                        }
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
            
            
            Button {
                signInModel.signOut()
                UserDefaults.resetStandardUserDefaults()
                
                // Clears cookies so that user is logged out of their Spotify account and it can't be accessed by the next user
                HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                            records.forEach { record in
                                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                                print("[WebCacheCleaner] Record \(record) deleted")
                            }
                        }
                
            } label: {
                Text("Sign out")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.black)
//        .onAppear(perform: {
//            splitByDate = SplitByDate(posts: feedViewModel.myPosts)
//
//        })
//        .scaledToFill()
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

    }
    
}
