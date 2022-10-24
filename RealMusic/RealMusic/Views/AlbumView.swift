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
                .foregroundColor(Color("Grey"))
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
                             } catch let error {
                                 print(error.localizedDescription)
                             }
                         } else {
                             print("The file doesn not exist at path || may not have been downloaded yet")
                         }
                     }
                     downloadTask.resume()
                }

                
            
                
//                self.downloadAndSaveAudioFile(audioFile: "https://p.scdn.co/mp3-preview/c38334b15c21ce019c1e968367d6a4af03248074?cid=774b29d4f13844c495f206cafdad9c86") { (result) in
//                    switch result {
//                        case .success(let data) :
//                        print("success song \(data)")
//                        let sound = Sound(url: URL(string: data)!)
////                        sound?.play { completed in
////                            print("completed: \(completed)")
////                        }
//                        //createPostModel.createPost(post: data[0])
//
//                        case .failure(let error) :
//                            print()
//                        }
//                    }
               
            }
           
        }
        .background(Color("Dark Grey"))
        //.frame(minHeight: 100)
        .cornerRadius(10)
        
        
        
    }
        
//    func downloadAndSaveAudioFile(audioFile: String, completion: @escaping (Result<String, Error>) -> Void) {
//
//            //Create directory if not present
//            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            let documentDirectory = paths.first! as NSString
//            let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
//
//            do {
//                try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
//                print("directory created at \(soundDirPathString)")
//            } catch let error as NSError {
//                print("error while creating dir : \(error.localizedDescription)");
//            }
//
//            if let audioUrl = URL(string: audioFile) {     //http://freetone.org/ring/stan/iPhone_5-Alarm.mp3
//                // create your document folder url
//                let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
//                let documentsFolderUrl = documentsUrl.appendingPathComponent("Sounds")
//                // your destination file url
//                let destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
//
//                print(destinationUrl)
//                // check if it exists before downloading it
//                if FileManager().fileExists(atPath: destinationUrl.path) {
//                    print("The file already exists at path")
//                    completion(.success(destinationUrl.absoluteString))
//                } else {
//                    //  if the file doesn't exist
//                    //  just download the data from your url
//                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
//                        if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
//                            // after downloading your data you need to save it to your destination url
//                            if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
//                                print("file saved")
//                                completion(.success(destinationUrl.absoluteString))
//                            } else {
//                                print("error saving file")
//                                //completion(.error(""))
//                            }
//                        }
//                    })
//                }
//            }
//        }
    
    struct AlbumView_Previews: PreviewProvider {
        static var previews: some View {
            AlbumView(album: Album(title: "Goodie Bag", artist: "Still Woozy" , cover: "KSG Cover", preview: ""))
        }
    }
}
