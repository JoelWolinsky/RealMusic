//
//  File.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 25/01/2023.
//

import Foundation
import SwiftUI

// A single post consisting of the song being posted and also the user posting it
struct YourPostView: View {
    @State var post: Post
    @StateObject var reactionViewModel: ReactionViewModel
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    @StateObject var userViewModel: UserViewModel

    
    @State var showReactionsList = false

    
    
    
    var body: some View {
        ZStack {
            VStack {
                ZStack{
                    VStack {
                        if let url = URL(string: post.cover ?? "") {
                            CacheAsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .cornerRadius(7)
                                        .padding(.bottom, 5)
                                    
                                case .failure(let error):
                                    //                    //print(error)
                                    Text("fail")
                                case .empty:
                                    // preview loader
                                    Rectangle()
                                        .cornerRadius(7)
                                        .padding(.bottom, 5)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    ReactionsView(reactionViewModel: reactionViewModel, post: post, emojiSize: 15)
                        //.padding(.leading, 10)
                        .offset(x: 5, y: 10)
                        .onTapGesture {
                            showReactionsList.toggle()
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .bottom)
                }
                .frame(maxWidth: 125, maxHeight: 125)

                
                Text(post.title ?? "")
                    .frame(maxWidth: .infinity, maxHeight: 25, alignment: .center)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    

                Text("\(post.datePosted.formatted(date: .omitted, time: .standard))")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 15))
                    .foregroundColor(Color("Grey 1"))
                
                
                
            }
            .padding(20)
            //.scaledToFill
            .frame(height:450)
            //.background(.black)
            .foregroundColor(.white)
            .onAppear(perform: {
                print("fetching song name and title")
                spotifyAPI.getSong(ID: post.songID) { (result) in
                    switch result {
                    case .success(let data) :
                        print("success \(data)")
                        post.title = data[0]
                        post.artist = data[1]
                    case .failure(let error) :
                        print()
                    }
                }
            })
            
            
            


            
            
        }
        .padding(.bottom, 40)
        .sheet(isPresented: $showReactionsList) {
            PostReactionsListView(reactionViewModel: reactionViewModel, userViewModel: userViewModel)
                .presentationDetents([.medium])
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            print("App is active")
            
            reactionViewModel.fetchReactions(id: post.id ?? "")

        }
       
        
    }
}

