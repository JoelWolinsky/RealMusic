//
//  SearchView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/10/2022.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    @State var name: String = "Tim"
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    
    
    @State var searchResults: [SpotifySong] = []
    
    var body: some View {
        VStack {
            Text("Hello \(name)")
            TextField("Type your name", text: $name)
                .background(.blue)
                .onSubmit {
                    print(name)
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
                }
            ForEach(searchResults) { song in
                Text("searchview \(song.songID)")
                SearchResultView(song: song)
                //Text(song.title ?? "placeholder")

            }
        }
        
    }
    
    
    
    
    
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            SearchView()
        }
    }
}

