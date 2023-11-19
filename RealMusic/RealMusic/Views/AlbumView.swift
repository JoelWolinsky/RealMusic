//
//  AlbumView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 13/10/2022.
//

import AVFoundation
import Foundation
import SwiftUI

var audioPlayer: AVAudioPlayer!

//View of the song in a post and the info linked to that song, eg song name and artist
struct AlbumView: View {
    let album: Album
    @State var playButton: String = "pause.fill"
    @State var playButtonColour: Color = .clear
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
    @State var postID: String
    @Binding var emojiPickerOpacity: Int
    @State var noPreview = false
    @Binding var scrollViewContentOffset: CGFloat
    @State var scrollViewContentOffsetCounter = 0
    @State var scrollViewContentOffsetPrev = CGFloat(0)
    @Binding var showUserDropDown: Bool

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if let url = URL(string: album.cover ?? "") {
                        CacheAsyncImage(url: url) { phase in
                            switch phase {
                            case let .success(image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(7)
                                    .padding(.bottom, 5)

                            case let .failure(error):
                                Text("fail")
                            case .empty:
                                Rectangle()
                                    .scaledToFill()
                                    .cornerRadius(7)
                                    .padding(.bottom, 5)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    Image(systemName: playButton)
                        .font(.system(size: 100))
                        .foregroundColor(playButtonColour)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
            }
            Image(systemName: "face.smiling")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 10, y: 10)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.0)) {
                        if longPress == 10 {
                            longPress = 0
                            disableScroll = 1000
                            blur = 0
                            showEmojiLibrary = false
                            showPicker = false
                            showUserDropDown = false
                            chosenPostID = ""
                        } else {
                            disableScroll = 0
                            longPress = 10
                            showPicker = true
                            chosenPostID = postID
                            blur = 20
                        }
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                    }
                }
        }
        .padding(20)
        .background(Color("Grey 3"))
        .cornerRadius(10)
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.0)) {
                if longPress == 10 {
                    longPress = 0
                    disableScroll = 1000
                    blur = 0
                    showEmojiLibrary = false
                    showPicker = false
                    showUserDropDown = false
                    chosenPostID = ""
                } else {
                    // play and pause song
                    if noPreview == false {
                        if self.playButton == "play.fill" {
                            self.playButton = "pause.fill"
                            audioPlayer.pause()
                            withAnimation(.easeIn(duration: 0.5)) {
                                playButtonColour = .white
                            }
                            withAnimation(.easeIn(duration: 0.5).delay(2)) {
                                playButtonColour = .clear
                            }
                        } else {
                            var downloadTask: URLSessionDownloadTask
                            if album.preview != nil && album.preview != "" {
                                self.playButton = "play.fill"
                                withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                                    playButtonColour = .white
                                }
                                withAnimation(.easeIn(duration: 0.5).delay(2)) {
                                    playButtonColour = .clear
                                }
                                downloadTask = URLSession.shared.downloadTask(with: URL(string: album.preview)!) { url, _, error in
                                    if let downloadedPath = url?.path, FileManager().fileExists(atPath: downloadedPath) {
                                        do {
                                            audioPlayer = try AVAudioPlayer(contentsOf: url!)
                                            guard let player = audioPlayer else {
                                                return
                                            }
                                            // To play even if phone on silent
                                            do {
                                                try AVAudioSession.sharedInstance().setCategory(.playback)
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            player.prepareToPlay()
                                            player.play()
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    } else {
                                        print("The file doesn not exist at path || may not have been downloaded yet")
                                    }
                                }
                                downloadTask.resume()
                            } else {
                                noPreview = true
                            }
                        }
                    }
                }
                showPicker = false
            }
        }
        .onLongPressGesture(perform: {
            withAnimation(.easeIn(duration: 0.2)) {
                if longPress == 10 {
                    longPress = 0
                    disableScroll = 1000
                    blur = 0
                    showEmojiLibrary = false
                    showPicker = false
                } else {
                    disableScroll = 0
                    longPress = 10
                    showPicker = true
                    chosenPostID = postID
                    blur = 20
                }
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
            }
        })
        .blur(radius: CGFloat(blur))
        .onChange(of: longPress) { _ in
            if longPress == 0 && showPicker == true {
                showPicker = false
            }
        }
        // Pauses playback when the user scrolls on
        .onChange(of: scrollViewContentOffset, perform: { _ in
            if self.playButton == "play.fill" {
                if scrollViewContentOffsetCounter > 70 {
                    self.playButton = "pause.fill"
                    audioPlayer.pause()
                    withAnimation(.easeIn(duration: 0.5)) {
                        playButtonColour = .white
                    }
                    withAnimation(.easeIn(duration: 0.5).delay(2)) {
                        playButtonColour = .clear
                    }
                    scrollViewContentOffsetCounter = 0
                } else {
                    if scrollViewContentOffset > 0 {
                        if scrollViewContentOffset > scrollViewContentOffsetPrev {
                            scrollViewContentOffsetCounter += 1
                        } else {
                            scrollViewContentOffsetCounter = 0
                        }
                    } else {
                        if scrollViewContentOffset < scrollViewContentOffsetPrev {
                            scrollViewContentOffsetCounter += 1
                        } else {
                            scrollViewContentOffsetCounter = 0
                        }
                    }
                    scrollViewContentOffsetPrev = scrollViewContentOffset
                }
            }

        })
    }
}

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}
