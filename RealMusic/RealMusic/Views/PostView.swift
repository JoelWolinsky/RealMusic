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
    
    @StateObject var blurModel: BlurModel
    
    @State var chosenEmoji = Emoji(emoji: "", description: "", category: "")
    @State var emojiSelected = false
    
    @Binding var disableScroll: Int
    
    @StateObject var emojiCatalogue: EmojiCatalogue
    
    
    @State var showEmojiLibrary = false
    
    @State var showPicker: Bool
    


    
    var body: some View {
        
        
        ZStack {
            VStack {
                Text("@" + (post.id ?? ""))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                AlbumView(album: Album(title: post.title ?? "placeholder",artist: post.artist ?? "placeholder" ,cover: post.cover ?? "KSG Cover", preview: post.preview ?? ""))
                //.padding(.bottom, 50)
                
                ReactionsView(reactionViewModel: reactionViewModel, postUID: post.id ?? "")
                    .padding(.leading, 10)
                    .offset(y: -20)
                
            }
            .padding(20)
            //.scaledToFill
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(.black)
            .foregroundColor(.white)
            .onAppear(perform: {
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
                
                
                //            feedViewModel.fetchReactions(postUID: post.id ?? "") { (result) in
                //                print("got reactions \(result.count)")
                //                post.reactions = result
                //            }
                //
                
            })
            // Issue with having a long press on a scroll item, so need to have an empty tap gesture before
            .onTapGesture {
                print("tap post")
                if longPress == 10 {
                    print(10)
                    longPress = 0
                    disableScroll = 1000
                    blurModel.blur = 0
                    showEmojiLibrary = false
                    showPicker = false


                }
                showPicker = false

            }
            .onLongPressGesture(perform: {
                print("long press post")
                if longPress == 10 {
                    print(10)
                    longPress = 0
                    disableScroll = 1000
                    blurModel.blur = 0
                    showEmojiLibrary = false
                    showPicker = false

                } else {
                    print(0)
                    disableScroll = 0
                    longPress = 10
                    showPicker = true
                    chosenPostID = post.id ?? ""
                    blurModel.blur = 20
                    
                }
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
                
                //blurModel.blur = 10
                
            })
            .blur(radius:CGFloat(blurModel.blur))
            

            
            if showPicker == true {
                ZStack {
//                    Rectangle()
//                        .foregroundColor(.purple)
//                        .opacity(0.5)
//                        .frame(height: 2000, alignment: .center)
//                        .offset(y:-1000)
//                        .onTapGesture {
//                            print("z tapped")
//                            longPress = 0
//                            disableScroll = 1000
//                            blurModel.blur = 0
//                            showEmojiLibrary = false
//                            showPicker = false
//                        }
                    VStack {
                        if let url = URL(string: post.cover ?? ""){
                            CacheAsyncImage(url: url)  { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 200, maxHeight: 200)
                                        .padding(.bottom, 20)
                                    
                                case .failure(let error):
                                    //                    //print(error)
                                    Text("fail")
                                case .empty:
                                    Rectangle()
                                        .scaledToFill()
                                        .cornerRadius(10)
                                        .padding(20)
                                        .foregroundColor(.green)
                                }
                            }
                            .frame(maxWidth: 200, maxHeight: 200)
                            .padding(.bottom, 20)
                            
                        }
                        EmojiPickerView(postUID: chosenPostID, cover: post.cover ?? "", longPress: $longPress, chosenEmoji: $chosenEmoji, emojiSelected: $emojiSelected, blurModel: blurModel, disableScroll: $disableScroll, reactionViewModel: reactionViewModel, emojiCatalogue: emojiCatalogue, showEmojiLibrary: $showEmojiLibrary, showPicker: $showPicker)
                        
                        
                    }
                    .offset(y: 100)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                    
                }
            }
        }
        
        .onChange(of: longPress) { change in
            if longPress == 0 && showPicker == true {
                print("yes \(post.id)")
                showPicker = false
            }
        }
//        .sheet(isPresented: $showEmojiLibrary) {
//                    EmojiLibraryView()
//                .presentationDetents([.medium])
//
//                }
        
    }
    
    
    
//    struct PostView_Previews: PreviewProvider {
//        static var previews: some View {
//            PostView(post: Post(songID: "xcv", uid: "This uid test", username: "Joel", cover: "KSG Cover"))
//            
//        }
//    }
}
