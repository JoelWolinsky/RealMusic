//
//  AlbumView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 13/10/2022.
//

import Foundation
import SwiftUI
import AVFoundation

var audioPlayer: AVAudioPlayer!

// View of the song in a post and the info linked to that song, eg song name and artist
struct AlbumView: View {
    
    let album: Album
    @State var playButton: String = "play.circle.fill"
    
    @StateObject var reactionViewModel: ReactionViewModel
    
    @Binding var longPress: Int
    @Binding var chosenPostID: String
    
    @Binding var blur: Int
    
    @State var chosenEmoji = Emoji(emoji: "", description: "", category: "")
    @State var emojiSelected = false
    
    @Binding var disableScroll: Int
    
    @StateObject var emojiCatalogue: EmojiCatalogue
    
    @State var showEmojiLibrary = false
    
    @Binding var showPicker: Bool
    
    @State  var postID: String
    
    @Binding var emojiPickerOpacity: Int
    
    var body: some View {
        ZStack {
            VStack {
                if let url = URL(string: album.cover ?? "") {
                    CacheAsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(7)
                                .padding(.bottom, 5)
                            
                        case .failure(let error):
                            //                    //print(error)
                            Text("fail")
                        case .empty:
                            // preview loader
                            Rectangle()
                                .scaledToFill()
                                .cornerRadius(7)
                                .padding(.bottom, 5)
                                .foregroundColor(.green)
                        }
                    }
                }
                    

                Text(album.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                
                Text(album.artist)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 10)
                    .foregroundColor(Color("Grey 1"))
                    .font(.system(size: 20))
                
                Spacer()
//                ZStack {
//                    Rectangle()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.black)
//                    Image(systemName: playButton)
//                        .font(.system(size:70))
//                        .foregroundColor(.green)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
//                .padding(20)
//                .onTapGesture {
//
//                    if self.playButton == "pause.circle.fill" {
//                        self.playButton = "play.circle.fill"
//                        audioPlayer.pause()
//
//                    } else {
//                        var downloadTask:URLSessionDownloadTask
//                        print("album prev: \(album.preview)")
//                        print()
//                        if album.preview != nil && album.preview != "" {
//                            downloadTask = URLSession.shared.downloadTask(with: URL(string: album.preview)!) { (url, response, error) in
//                                //self.play(url: url)
//                                print("playing sound")
//                                print("url: \(url)")
//
//                                if let downloadedPath = url?.path, FileManager().fileExists(atPath: downloadedPath) {
//                                    do {
//                                        audioPlayer = try AVAudioPlayer(contentsOf: url!)
//                                        guard let player = audioPlayer else { return }
//
//                                        player.prepareToPlay()
//                                        player.play()
//                                        self.playButton = "pause.circle.fill"
//                                        print("playing")
//                                    } catch let error {
//                                        print(error.localizedDescription)
//                                    }
//                                } else {
//                                    print("The file doesn not exist at path || may not have been downloaded yet")
//                                }
//                            }
//                            downloadTask.resume()
//                        }
//
//                    }
//
//                }
                
               
            }

        }
        .padding(20)
        .background(Color("Grey 3"))
        .cornerRadius(10)
        .onTapGesture {
            print("tap post")
            withAnimation(.easeIn(duration: 0.2)) {
                
                if longPress == 10 {
                    print(10)
                    longPress = 0
                    disableScroll = 1000
                    blur = 0
                    showEmojiLibrary = false
                    showPicker = false
                    
                    
                }
                showPicker = false
            }
        }
        .onLongPressGesture(perform: {
            withAnimation(.easeIn(duration: 0.2)) {
                print("long press post")
                if longPress == 10 {
                    print(10)
                    longPress = 0
                    disableScroll = 1000
                    blur = 0
                    showEmojiLibrary = false
                    
                    
                    showPicker = false
                    
                } else {
                    print(0)
                    disableScroll = 0
                    longPress = 10
                    showPicker = true
                    
                    chosenPostID = postID
                    
                    
                    //chosenPostID = post.id ?? ""
                    blur = 20
                    
                }
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
            }
                //blurModel.blur = 10
            
        })
        .blur(radius:CGFloat(blur))
        
        
        .onChange(of: longPress) { change in
            if longPress == 0 && showPicker == true {
                //print("yes \(post.id)")
                showPicker = false
            }
        }
        
    }
    
//    struct AlbumView_Previews: PreviewProvider {
//        static var previews: some View {
//            AlbumView(album: Album(title: "Goodie Bag", artist: "Still Woozy" , cover: "KSG Cover", preview: ""))
//        }
//    }
}


extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
