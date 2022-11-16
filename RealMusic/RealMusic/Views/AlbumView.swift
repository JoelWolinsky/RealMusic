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
    

    
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: album.cover)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(10)
                    .padding(20)
            } placeholder: {
                Color.orange
            }
            
            Text(album.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
                .foregroundColor(.white)
                .font(.system(size: 25))
            
            Text(album.artist)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
                .padding(.top, -40)
                .foregroundColor(Color("Grey 1"))
                .font(.system(size: 20))
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                Image(systemName: playButton)
                    .font(.system(size:70))
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(20)
            .onTapGesture {
                
                if self.playButton == "pause.circle.fill" {
                    self.playButton = "play.circle.fill"
                    audioPlayer.pause()
                    
                } else {
                    var downloadTask:URLSessionDownloadTask
                    print("album prev: \(album.preview)")
                    print()
                    if album.preview != nil && album.preview != "" {
                        downloadTask = URLSession.shared.downloadTask(with: URL(string: album.preview)!) { (url, response, error) in
                             //self.play(url: url)
                             print("playing sound")
                             print("url: \(url)")

                             if let downloadedPath = url?.path, FileManager().fileExists(atPath: downloadedPath) {
                                 do {
                                     audioPlayer = try AVAudioPlayer(contentsOf: url!)
                                     guard let player = audioPlayer else { return }

                                     player.prepareToPlay()
                                     player.play()
                                     self.playButton = "pause.circle.fill"
                                     print("playing")
                                 } catch let error {
                                     print(error.localizedDescription)
                                 }
                             } else {
                                 print("The file doesn not exist at path || may not have been downloaded yet")
                             }
                         }
                         downloadTask.resume()
                    }
                    
                }
               
            }
           
        }
        .background(Color("Grey 3"))
        //.frame(minHeight: 100)
        .cornerRadius(10)
   
    }
        
    
    struct AlbumView_Previews: PreviewProvider {
        static var previews: some View {
            AlbumView(album: Album(title: "Goodie Bag", artist: "Still Woozy" , cover: "KSG Cover", preview: ""))
        }
    }
}
