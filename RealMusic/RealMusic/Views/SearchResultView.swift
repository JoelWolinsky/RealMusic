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
    @Binding var searchToggle: Bool

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: song.cover ?? "KSG Cover")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(2)
                    .frame(width: 50, height: 50)
            } placeholder: {
                Color.black
                    .frame(width: 50, height: 50)
            }
            VStack {
                Text(song.title ?? "placeholder")
                    .onAppear(perform: { print("songid \(song.songID)")
                        spotifyAPI.getSong(ID: song.songID ?? "") { result in
                            switch result {
                            case let .success(data):
                                song.title = data[0]
                                song.artist = data[1]
                            case let .failure(error):
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
                .background(.white)
                .cornerRadius(3)
                .frame(maxWidth: 60, maxHeight: .infinity, alignment: .bottomTrailing)
                .foregroundColor(.black)
                .onTapGesture {
                    withAnimation {
                        searchToggle.toggle()
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM yyyy"
                    let date = formatter.string(from: Date())
                    createPostModel.createPost(
                        post: Post(id: "\(date)-\(UserDefaults.standard.value(forKey: "uid"))",
                                   songID: song.songID,
                                   uid: UserDefaults.standard.value(forKey: "uid") as! String,
                                   username: UserDefaults.standard.value(forKey: "username") as! String ?? "",
                                   cover: song.cover,
                                   datePosted: Date(),
                                   preview: song.preview_url))
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
        .padding(10)
        .background(Color("Grey 3"))
        .cornerRadius(5)
    }
}
