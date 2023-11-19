//
//  PostView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import Foundation
import SwiftUI

// A single post consisting of the song being posted and also the user posting it
struct PostView: View {
    @State var post: Post
    @ObservedObject var spotifyAPI = SpotifyAPI()
    @StateObject var reactionViewModel: ReactionViewModel
    @Binding var longPress: Int
    @Binding var chosenPostID: String
    @Binding var blur: Int
    @State var chosenEmoji = Emoji(emoji: "", description: "", category: "")
    @State var emojiSelected = false
    @Binding var disableScroll: Int
    @StateObject var emojiCatalogue: EmojiCatalogue
    @State var showEmojiLibrary = false
    @State var showPicker: Bool
    @State var animatePicker = false
    @State var emojiPickerOpacity = 1
    @State var showReactionsList = false
    @StateObject var userViewModel: UserViewModel
    @Binding var scrollViewContentOffset: CGFloat
    @State var profilePic = String()
    @Binding var showUserDropDown: Bool
    @State var following: Bool

    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.0)) {
                        showUserDropDown.toggle()
                        if longPress == 10 {
                            longPress = 0
                            disableScroll = 1000
                            blur = 0
                            showUserDropDown = false
                            chosenPostID = ""

                        } else {
                            disableScroll = 0
                            longPress = 10
                            showUserDropDown = true
                            blur = 20
                            chosenPostID = post.id ?? ""
                        }
                    }
                }, label: {
                    HStack {
                        if let url = URL(string: profilePic) {
                            CacheAsyncImage(url: url) { phase in
                                switch phase {
                                case let .success(image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case let .failure(error):
                                    Rectangle()
                                        .background(.black)
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                case .empty:
                                    Rectangle()
                                        .background(.black)
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                        } else {
                            Rectangle()
                                .background(.black)
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30)
                        }
                        VStack {
                            Text(post.username ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(post.datePosted.formatted(date: .abbreviated, time: .shortened))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 15))
                                .foregroundColor(Color("Grey 1"))
                        }
                    }
                    .blur(radius: CGFloat(blur))
                })
                AlbumView(album: Album(title: post.title ?? "placeholder", artist: post.artist ?? "placeholder", cover: post.cover ?? "KSG Cover", preview: post.preview ?? ""), reactionViewModel: reactionViewModel, longPress: $longPress, chosenPostID: $chosenPostID, blur: $blur, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: $showPicker, postID: post.id ?? "", emojiPickerOpacity: $emojiPickerOpacity, scrollViewContentOffset: $scrollViewContentOffset, showUserDropDown: $showUserDropDown)
            }
            .padding(20)
            .foregroundColor(.white)
            .onAppear(perform: {
                spotifyAPI.getSong(ID: post.songID) { result in
                    switch result {
                    case let .success(data):
                        post.title = data[0]
                        post.artist = data[1]
                    case let .failure(error):
                        print()
                    }
                }
            })
            ReactionsView(reactionViewModel: reactionViewModel, post: post, emojiSize: 20.0)
                .padding(.leading, 30)
                .blur(radius: CGFloat(blur))
                .onTapGesture {
                    showReactionsList.toggle()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            if showPicker == true {
                ZStack {
                    VStack {
                        EmojiPickerCoverView(cover: post.cover ?? "")
                        EmojiPickerView(postUID: post.id ?? "", cover: post.cover ?? "", longPress: $longPress, chosenEmoji: $chosenEmoji, emojiSelected: $emojiSelected, blur: $blur, disableScroll: $disableScroll, reactionViewModel: reactionViewModel, emojiCatalogue: emojiCatalogue, showEmojiLibrary: $showEmojiLibrary, showPicker: $showPicker)
                        PostDropDownView(trackID: post.songID ?? "", spotifyAPI: spotifyAPI, showPicker: $showPicker, longPress: $longPress, blur: $blur, disableScroll: $disableScroll)
                    }
                    .offset(y: -30)
                }
                .opacity(Double(emojiPickerOpacity))
            }
            if showUserDropDown && chosenPostID == post.id {
                UserDropDownView(username: post.username ?? "", spotifyAPI: spotifyAPI, showPicker: $showPicker, longPress: $longPress, blur: $blur, disableScroll: $disableScroll, showUserDropDown: $showUserDropDown, userViewModel: userViewModel, following: following)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 50)
            }
        }
        .sheet(isPresented: $showReactionsList) {
            PostReactionsListView(reactionViewModel: reactionViewModel, userViewModel: userViewModel)
                .presentationDetents([.medium])
        }
        .onAppear(perform: {
            userViewModel.fetchProfilePic(uid: post.uid) { profile in
                profilePic = profile
            }
        })
    }
}
