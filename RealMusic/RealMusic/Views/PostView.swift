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
    
    @State var animatePicker = false
    


    
    var body: some View {
        
        
        ZStack {
            VStack {
                Text("@" + (post.id ?? ""))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .blur(radius:CGFloat(blurModel.blur))

                
                
                AlbumView(album: Album(title: post.title ?? "placeholder",artist: post.artist ?? "placeholder" ,cover: post.cover ?? "KSG Cover", preview: post.preview ?? ""), reactionViewModel: reactionViewModel, longPress: $longPress, chosenPostID: $chosenPostID, blurModel: blurModel, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: $showPicker )
                //.padding(.bottom, 50)
                
                ReactionsView(reactionViewModel: reactionViewModel, postUID: post.id ?? "")
                    .padding(.leading, 10)
                    .offset(y: -20)
                    .blur(radius:CGFloat(blurModel.blur))

                
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
            
            //        .sheet(isPresented: $showEmojiLibrary) {
            //                    EmojiLibraryView()
            //                .presentationDetents([.medium])
            //
            //                }
            if showPicker == true {
                ZStack {
                    VStack {
                        if let url = URL(string: post.cover ?? ""){
                            CacheAsyncImage(url: url)  { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        //.scaledToFill()
                                        .frame(width: showPicker ? 200 : 0, height: showPicker ? 200 : 0)
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
                            .frame(width: showPicker ? 200 : 0, height: showPicker ? 200 : 0)
                            //.frame(width: 200, height: 200)
                            .padding(.bottom, 20)
                            
                        }
                        EmojiPickerView(postUID: post.id ?? "", cover: post.cover ?? "", longPress: $longPress, chosenEmoji: $chosenEmoji, emojiSelected: $emojiSelected, blurModel: blurModel, disableScroll: $disableScroll, reactionViewModel: reactionViewModel, emojiCatalogue: emojiCatalogue, showEmojiLibrary: $showEmojiLibrary, showPicker: $showPicker)
                        
                        
                    }
                    .offset(y: 100)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                    
                }
                .onAppear(perform: {
                    print("animate picker 2 = \(animatePicker)")
                    withAnimation(.linear(duration: 5)) {
                        animatePicker = true
                        print("animate picker 2 = \(animatePicker)")

                    }
                })
                
            }
        }
        
    }
    
    
//    struct PostView_Previews: PreviewProvider {
//        static var previews: some View {
//            PostView(post: Post(songID: "xcv", uid: "This uid test", username: "Joel", cover: "KSG Cover"))
//            
//        }
//    }
}
