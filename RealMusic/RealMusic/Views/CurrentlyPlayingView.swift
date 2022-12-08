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
    
    @State private var backgroundColor: Color = Color(.black)


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
                          .onAppear(perform: {
                              imageView = image
                              
                              let uiColor = imageView.asUIImage().averageColor ?? .clear
                              backgroundColor = Color(uiColor)
                              print("backgroundColor \(backgroundColor)")
                                  
                          })
                          .onChange(of: image) { newImage in
                              print("newimage")
                              print(backgroundColor)

                              imageView = newImage
                              let uiColor = imageView.asUIImage().averageColor ?? .clear
                              backgroundColor = Color(uiColor)
                              print(backgroundColor)
                          }
                          
                } placeholder: {
                    Color.orange
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
                    Text(song.title ?? "")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        //.padding(10)
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                    
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
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .padding(.top, -25)
                .font(.system(size: 17))
                .onTapGesture {
                    postButtonColour = Color(.clear)
                    //let transition = .transition(.slide)
                    postButtonText = "Posted"
                    //currentSongBackground = Color(.green)
                    createPostModel.createPost(
                        post: Post(songID: song.songID,
                                   uid: UserDefaults.standard.value(forKey: "uid") as! String,
                                      username: UserDefaults.standard.value(forKey: "username") as! String ?? "",
                                      cover: song.cover,
                                      preview: song.preview_url))
                }
            
            
        }
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

