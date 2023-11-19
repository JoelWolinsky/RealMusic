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
    @State var searchError = false
    @State var rerun = false

    var body: some View {
        let binding = Binding<String>(get: {
            self.searchText
        }, set: {
            self.searchText = $0
        })
        return
            HStack {
                VStack {
                    Button {
                        withAnimation {
                            searchToggle.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("Grey 1"))
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search...").foregroundColor(Color("Grey 1"))
                            }
                    }
                    .padding(10)
                    .frame(height: 40)
                    .background(.white)
                    .cornerRadius(13)
                    .padding(30)
                    .padding(.top, -40)
                    .foregroundColor(.black)
                    ScrollView {
                        ForEach(searchResults) { song in
                            SearchResultView(song: song, createPostModel: createPostModel, searchToggle: $searchToggle)
                        }
                    }
                }
                .background(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onChange(of: searchText, perform: { _ in
                if searchText != "" {
                    spotifyAPI.search(input: searchText) { result in
                        switch result {
                        case let .success(data):
                            searchResults = []
                            searchResults = data
                            searchError = false
                        case let .failure(error):
                            searchError = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                if searchError {
                                    rerun.toggle()
                                }
                            }
                        }
                    }
                }

            })
            .onChange(of: rerun, perform: { _ in
                if searchText != "" {
                    spotifyAPI.search(input: searchText) { result in
                        switch result {
                        case let .success(data):
                            searchResults = []
                            searchResults = data
                            searchError = false
                        case let .failure(error):
                            searchError = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                if searchError {
                                    rerun.toggle()
                                }
                            }
                        }
                    }
                }
            })
    }
    struct SearchView_Previews: PreviewProvider {
        @State static var toggle = false
        static var previews: some View {
            SearchView(searchToggle: $toggle)
        }
    }
}
