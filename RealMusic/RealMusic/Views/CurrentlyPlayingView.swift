//
//  CurrentlyPlayingView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 16/11/2022.
//

import AVFoundation
import Foundation
import SwiftUI

// View of the song in a post and the info linked to that song, eg song name and artist
struct CurrentlyPlayingView: View {
    let song: SpotifySong
    @StateObject var createPostModel: CreatePostViewModel
    @State var postButtonColour = Color(.black)
    @State var postButtonText = "Post"
    @State var currentSongBackground = Color("Grey 1")
    @State var imageView = Image("")
    @State private var backgroundColor: Color = .init("Grey 3")
    @Binding var searchToggle: Bool
    @Binding var currentSongPosted: Bool

    var body: some View {
        HStack {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: song.cover ?? "")) { image in
                        image
                            .resizable()
                            .onAppear(perform: {
                                imageView = image
                                withAnimation(.easeIn(duration: 0.5)) {
                                    let uiColor = imageView.asUIImage().averageColor ?? .clear
                                    backgroundColor = Color(uiColor)
                                }
                            })
                            .onChange(of: image) { newImage in
                                withAnimation(.easeIn(duration: 0.5)) {
                                    imageView = newImage
                                    let uiColor = imageView.asUIImage().averageColor ?? .clear
                                    backgroundColor = Color(uiColor)
                                }
                            }
                    } placeholder: {
                        Color.black
                    }
                    .scaledToFit()
                    .cornerRadius(5)
                    .padding(10)
                    VStack {
                        if song.title == "" {
                            Text("Nothing currently playing on your Spotify")
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .foregroundColor(Color("Grey 1"))
                                .font(.system(size: 15))
                        } else {
                            Text(song.title ?? "")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                        }
                        Text(song.artist ?? "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.top, -20)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 30)
                }
                Text(postButtonText)
                    .frame(width: 80, height: 30)
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .foregroundColor(song.title == "" ? Color("Grey 1") : .white)
                    .padding(.bottom, 5)
                    .padding(.top, -25)
                    .font(.system(size: 17))
                    .brightness(-0.1)
                    .onTapGesture {
                        if song.title != "" {
                            currentSongPosted.toggle()
                            postButtonColour = Color(.clear)
                            postButtonText = "Posted"
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
            }
            Button {
                withAnimation {
                    searchToggle.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .padding(.trailing, 20)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }
        }
        .onChange(of: song.title, perform: { _ in
            postButtonText = "Post"
            postButtonColour = Color(.black)
        })
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
