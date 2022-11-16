//
//  CurrentlyPlayingView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 16/11/2022.
//

import Foundation
import SwiftUI
import AVFoundation


// View of the song in a post and the info linked to that song, eg song name and artist
struct CurrentlyPlayingView: View {
    
    let song: SpotifySong
    
    @StateObject var createPostModel: CreatePostViewModel

    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: song.cover ?? "")) { image in
                    image
                          .resizable()
    //                    .scaledToFit()
    //                    //.frame(width: 60, height: 60)
    //                    .cornerRadius(2)
    //                    .padding(5)
                } placeholder: {
                    Color.orange
                }
                //.resizable()
                .scaledToFit()
                //.frame(width: 60, height: 60)
                .cornerRadius(5)
                .padding(10)
                
                VStack {
                    Text(song.title ?? "")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        //.padding(10)
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                    
                    Text(song.artist ?? "")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        //.padding(10)
                        .padding(.top, -20)
                        .foregroundColor(Color("Grey 2"))
                        .font(.system(size: 15))
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
            
            Text("Post")
                .frame(width: 80, height: 30)
                .background(.black)
                .cornerRadius(15)
                .foregroundColor(.white)
                .padding(.bottom, 15)
                .padding(.top, -10)
                .font(.system(size: 17))
                .onTapGesture {
                    createPostModel.createPost(
                        post: Post(songID: song.songID,
                                      uid: "dadsads",
                                      username: "placeholder",//UserDefaults.standard.value(forKey: "Username") as! String ?? "",
                                      cover: song.cover,
                                      preview: song.preview_url))
                }
            
        }
        .background(Color("Grey 1"))
        //.scaledToFill()
        .cornerRadius(10)
   
    }
        
    
    struct CurrentlyPlayingView_Previews: PreviewProvider {
        static var previews: some View {
            CurrentlyPlayingView(song:  SpotifySong(songID: "", title: "", artist: "", uid: "", cover: ""), createPostModel: CreatePostViewModel(uid: ""))
        }
    }
}

