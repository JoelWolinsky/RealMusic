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
    
    @State var postButtonColour = Color(.black)
    @State var postButtonText = "Post"
    @State var currentSongBackground = Color("Grey 1")
    @State var imageView = Image("")
    
    @State private var backgroundColor: Color = Color("Grey 3")
    
    @Binding var searchToggle: Bool
    @Binding var currentSongPosted: Bool


    var body: some View {
        HStack{
            VStack {
                
                HStack {
                    AsyncImage(url: URL(string: song.cover ?? "")) { image in
                        image
                            .resizable()
                        //                    .scaledToFit()
                        //                    //.frame(width: 60, height: 60)
                        //                    .cornerRadius(2)
                        //                    .padding(5)
                            .onAppear(perform: {
                                imageView = image
                                withAnimation(.easeIn(duration: 0.5)) {
                                    let uiColor = imageView.asUIImage().averageColor ?? .clear
                                    backgroundColor = Color(uiColor)
                                    print("backgroundColor \(backgroundColor)")
                                }
                            })
                            .onChange(of: image) { newImage in
                                withAnimation(.easeIn(duration: 0.5)) {
                                    
                                    print("newimage")
                                    print(backgroundColor)
                                    
                                    imageView = newImage
                                    let uiColor = imageView.asUIImage().averageColor ?? .clear
                                    backgroundColor = Color(uiColor)
                                    print(backgroundColor)
                                }
                            }
                        
                    } placeholder: {
                        Color.black
                    }
                    //                .onChange(of: imageView, perform: {
                    //                    print("colour change")
                    //                })
                    //.resizable()
                    .scaledToFit()
                    //.frame(width: 60, height: 60)
                    .cornerRadius(5)
                    .padding(10)
                    
                    VStack {
                        if song.title == "" {
                            Text("Nothing currently playing on your Spotify")
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            //.padding(10)
                                .foregroundColor(Color("Grey 1"))
                                .font(.system(size: 15))
                        } else {
                            Text(song.title ?? "")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            //.padding(10)
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                        }
                        
                        
                        Text(song.artist ?? "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        //.padding(10)
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
                    .background(postButtonColour)
                    .cornerRadius(15)
                    .foregroundColor(song.title == "" ? Color("Grey 1") : .white)
                    .padding(.bottom, 5)
                    .padding(.top, -25)
                    .font(.system(size: 17))
                    .onTapGesture {
                        if song.title != "" {
                            currentSongPosted.toggle()
                            postButtonColour = Color(.clear)
                            //let transition = .transition(.slide)
                            postButtonText = "Posted"
                            //currentSongBackground = Color(.green)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd MMM yyyy"
                            let date = formatter.string(from: Date())

                            createPostModel.createPost(
                                post: Post(id: ("\(date)-\(UserDefaults.standard.value(forKey: "uid"))"),
                                           songID: song.songID,
                                           uid: UserDefaults.standard.value(forKey: "uid") as! String,
                                           username: UserDefaults.standard.value(forKey: "username") as! String ?? "",
                                           cover: song.cover,
                                           datePosted: Date(),
                                           preview: song.preview_url
                                          ))
                        }
                    }
                
                
            }
            Button {
                withAnimation() {
                    searchToggle.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .padding(.trailing,20)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }
            
                
            
        }
        .onChange(of: song.title, perform: { value in
            postButtonText = "Post"
            postButtonColour = Color(.black)

            
        })
        .background(backgroundColor)
        //.scaledToFill()
        .cornerRadius(10)
//        .onAppear(perform: {
//            if let filePath = Bundle.main.path(forResource: song.cover ?? "", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = image
//            }
//        })
   
    }
        
    
//    struct CurrentlyPlayingView_Previews: PreviewProvider {
//        static var previews: some View {
//            CurrentlyPlayingView(song:  SpotifySong(songID: "", title: "", artist: "", uid: "", cover: ""), createPostModel: CreatePostViewModel(uid: ""))
//        }
//    }
}

