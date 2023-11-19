//
//  YourPostView.swift
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
                ZStack {
                    VStack {
                        if let url = URL(string: post.cover ?? "") {
                            CacheAsyncImage(url: url) { phase in
                                switch phase {
                                case let .success(image):
                                    image
                                        .resizable()
                                        .cornerRadius(7)
                                case let .failure(error):
                                    Text("fail")
                                case .empty:
                                    Rectangle()
                                        .cornerRadius(7)
                                        .padding(.bottom, 5)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    ReactionsView(reactionViewModel: reactionViewModel, post: post, emojiSize: 15)
                        .offset(x: 5, y: 10)
                        .onTapGesture {
                            showReactionsList.toggle()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
            .frame(height: 450)
            .foregroundColor(.white)
            .onAppear(perform: {
                spotifyAPI.getSong(ID: post.songID) { result in
                    switch result {
                    case let .success(data):
                        print("success \(data)")
                        post.title = data[0]
                        post.artist = data[1]
                    case let .failure(error):
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
            reactionViewModel.fetchReactions(id: post.id ?? "")
        }
    }
}
