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

    
    var body: some View {
        
        
        
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
        .onLongPressGesture(perform: {
            print("longpress")
            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
            impactHeavy.impactOccurred()
        })
        
        
    }
    
    
    
//    struct PostView_Previews: PreviewProvider {
//        static var previews: some View {
//            PostView(post: Post(songID: "xcv", uid: "This uid test", username: "Joel", cover: "KSG Cover"))
//            
//        }
//    }
}
