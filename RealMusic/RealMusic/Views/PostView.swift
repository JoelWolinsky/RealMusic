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
    
    @State var chosenEmoji = Emoji(emoji: "", name: "")
    @State var emojiSelected = false
    
    @Binding var disableScroll: Int
    
    
    

    
    var body: some View {
        
        
        ZStack {
            VStack {
                Text("@" + (post.username ?? ""))
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
                    longPress = 0
                    disableScroll = 1000
                    blurModel.blur = 0
                }
            }
            .onLongPressGesture(perform: {
                print("long press post")
                if longPress == 10 {
                    longPress = 0
                    disableScroll = 1000
                } else {
                    disableScroll = 0
                    longPress = 10
                    chosenPostID = post.id ?? ""
                    
                }
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
                
                blurModel.blur = 10
                
            })
            .blur(radius:CGFloat(blurModel.blur))

            
            if longPress == 10 {
                EmojiPickerView(postUID: chosenPostID, longPress: $longPress, chosenEmoji: $chosenEmoji, emojiSelected: $emojiSelected, blurModel: blurModel, disableScroll: $disableScroll)
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
