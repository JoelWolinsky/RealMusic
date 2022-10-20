//
//  PostView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import Foundation
import SwiftUI

struct PostView: View {
    @State var post: Post
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    
    var body: some View {
        
        
        
        VStack {
            Text("@" + (post.username ?? ""))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            AlbumView(album: Album(title: post.title ?? "placeholder", cover: post.cover ?? "KSG Cover"))
                //.padding(.bottom, 50)
            
        }
        .padding(20)
        //.scaledToFill
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(.black)
        .foregroundColor(.white)
        .onAppear(perform: {spotifyAPI.getSong(ID: post.songID) { (result) in
            switch result {
                case .success(let data) :
                print("success \(data)")
                post.title = data
                case .failure(let error) :
                    print()
                }
            }
        })
        


        
        
    }
    
    
    
    struct PostView_Previews: PreviewProvider {
        static var previews: some View {
            PostView(post: Post(songID: "xcv", uid: "This uid test", username: "Joel", cover: "KSG Cover"))
            
        }
    }
}
