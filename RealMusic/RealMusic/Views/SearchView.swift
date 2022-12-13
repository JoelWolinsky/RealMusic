//
//  SearchView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/10/2022.
//

import Foundation
import SwiftUI

// A view for user to search through the Spotify library to find a song to post
struct SearchView: View {
    
    @State var searchText: String = ""
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    
    @ObservedObject var createPostModel = CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2")

    @State var searchResults: [SpotifySong] = []
    
    @Binding var searchToggle: Bool
    
    
    
    var body: some View {
        
        let binding = Binding<String>(get: {
                    self.searchText
                }, set: {
                    self.searchText = $0
                    // do whatever you want here
                    print("String change \(searchText)")
                    spotifyAPI.search(input: searchText) { (result) in
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
        HStack {
            VStack {
                Button {
                    withAnimation {
                        searchToggle.toggle()
                    }
                } label: {
                    Text("Back")
                        .foregroundColor(.white)
                        .font(.system(size:20))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search ..", text: binding)

                    
                }
                    .padding(10)
                    .frame(height: 40)
                    .background(.green)
                    .cornerRadius(13)
                    .padding(30)
                    .padding(.top, -40)
                
                ScrollView {
                    ForEach(searchResults) { song in
                        //Text("searchview \(song.songID)")
                        SearchResultView(song: song, createPostModel: createPostModel, searchToggle: $searchToggle)
                        
                        
                        //Text(song.title ?? "placeholder")
                        
                    }
                }
                
            }
            .background(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    
    
    
    
    
    struct SearchView_Previews: PreviewProvider {
        @State static var toggle = false
        static var previews: some View {
            SearchView(searchToggle: $toggle)
        }
    }
}

