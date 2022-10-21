//
//  SearchView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/10/2022.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    @State var name: String = "Sunny"
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    
    @ObservedObject var createPostModel = CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2")

    @State var searchResults: [SpotifySong] = []
    
    
    
    var body: some View {
        
        let binding = Binding<String>(get: {
                    self.name
                }, set: {
                    self.name = $0
                    // do whatever you want here
                    print("String change \(name)")
                    spotifyAPI.search(input: name) { (result) in
                        switch result {
                            case .success(let data) :
                            print("success 123\(data)")
                            //createPostModel.createPost(post: data)
                            searchResults = []
                            searchResults = data
                            case .failure(let error) :
                            searchResults = []
                                print()
                            }
                        }

                })
        return
        VStack {

            TextField("Search...", text: binding)
                .background(.orange)
            
            ScrollView {
                ForEach(searchResults) { song in
                    //Text("searchview \(song.songID)")
                    SearchResultView(song: song, createPostModel: createPostModel)
                        

                    //Text(song.title ?? "placeholder")

                }
            }
            
        }
        .background(.black)
        
    }
    
    
    
    
    
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            SearchView()
        }
    }
}

