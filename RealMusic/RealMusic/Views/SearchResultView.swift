//
//  SearchResultView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/10/2022.
//

import Foundation
import SwiftUI

// A single song in the search results from the API
struct SearchResultView: View {
    
    @State var song: SpotifySong
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    
    var createPostModel: CreatePostViewModel

    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: song.cover ?? "KSG Cover")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(2)
                    //.padding(20)
                    .frame(width: 50, height: 50)
            } placeholder: {
                Color.orange
                    .frame(width: 50, height: 50)
            }
            
            VStack {
                Text(song.title ?? "placeholder")
                    .onAppear(perform: {print("songid \(song.songID)");
                        spotifyAPI.getSong(ID: song.songID ?? "") { (result) in
                        switch result {
                            case .success(let data) :
                            print("success \(data)")
                            song.title = data[0]
                            song.artist = data[1]

                            case .failure(let error) :
                                print()
                            }
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                
                Text(song.artist ?? "artist")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color("Grey 1"))
                    .font(.system(size: 15))

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            Text("Post")
                .frame(width: 60, height: 25)
                .background(.green)
                .cornerRadius(3)
                .frame(maxWidth: 60, maxHeight: .infinity, alignment: .bottomTrailing)
                .foregroundColor(.black)
                .onTapGesture {
                    print("tapped post")
                    print("song url: \(song.preview_url)")
                    createPostModel.createPost(
                        post: Post(songID: song.songID,
                                   uid: UserDefaults.standard.value(forKey: "uid") as! String,
                                      username: UserDefaults.standard.value(forKey: "username") as! String,
                                      cover: song.cover,
                                      preview: song.preview_url))
                }
                //.fontWeight(.bold)

            
            
                
  
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
        .padding(10)
        .background(Color("Grey 3"))
        .cornerRadius(5)
 
        
    }
    
    struct SearchResultsView_Previews: PreviewProvider {
        static var previews: some View {
            SearchResultView(song: SpotifySong(songID: "5GHIsNIT9QH2u9XYuA2xp8", title: "", artist: "",uid: "Joel Wolinsky", cover:"", preview_url: ""), createPostModel: CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2"))
        }
    }
    
}

