//
//  PostOptionsView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 05/12/2022.
//

import Foundation
import SwiftUI

struct PostDropDownView : View {
    
    @State private var animatePicker2 = false
    
    var trackID: String
    
    @StateObject var spotifyAPI: SpotifyAPI
    
    @Binding var showPicker: Bool
    @Binding var longPress: Int
    @Binding var blur: Int
    @Binding var disableScroll: Int

    
    var body: some View {
        VStack{
            ZStack{
                VStack(spacing: 0) {
                    Button(action: {
                        print("add to library")
                        spotifyAPI.addToLibrary(trackID: trackID)
                        
                        withAnimation(.easeIn(duration: 0.2)) {
                            showPicker = false
                            longPress = 0
                            blur = 0
                            disableScroll = 1000
                        }

                    }, label: {
                        HStack {
                            Text("Add to library")
                                .foregroundColor(.white)
                            Spacer ()
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: animatePicker2 ? 20 : 0))
                        }
                        .frame(maxHeight: animatePicker2 ? 10 : 0, alignment: .center)
                        .padding(20)
                        
                    })
                    .buttonStyle(DropDownButton())
                    
                    Button(action: {
                        print("add to queue")
                        spotifyAPI.addToQueue(trackID: trackID)
                        
                        withAnimation(.easeIn(duration: 0.2)) {
                            showPicker = false
                            longPress = 0
                            blur = 0
                            disableScroll = 1000
                        }

                    }, label: {
                        HStack {
                            Text("Add to queue")
                                .foregroundColor(.white)
                            Spacer ()
                            Image(systemName: "text.badge.plus")
                                .foregroundColor(.white)
                                .font(.system(size: animatePicker2 ? 20 : 0))
                        }
                        .frame(maxHeight: animatePicker2 ? 10 : 0, alignment: .center)
                        .padding(20)
                    })
                    .buttonStyle(DropDownButton())
                    
                    Button(action: {
                        print("add to playlist")
                        //spotifyAPI.addToPlaylist()
                        spotifyAPI.getUserID() { (userID) in
                            switch userID {
                            case .success(let data):
                                print("user id is \(data)")
                                spotifyAPI.getPlaylists(userSpotifyID: data, offset: 0) { (result) in
                                        print("Returned playlist id \(result)")
                                        spotifyAPI.addToPlaylist(playlistID: result, trackID: trackID)
                                  
                                    }
                            
                            case .failure(let error):
                                print("no id found")
                            }
                        }
                        
                        
                        
                        
                        
                        withAnimation(.easeIn(duration: 0.2)) {
                            showPicker = false
                            longPress = 0
                            blur = 0
                            disableScroll = 1000
                        }

                    }, label: {
                        HStack {
                            Text("Add to playlist")
                                .foregroundColor(.white)
                            Spacer ()
                            Image(systemName: "text.badge.plus")
                                .foregroundColor(.white)
                                .font(.system(size: animatePicker2 ? 20 : 0))
                        }
                        .frame(maxHeight: animatePicker2 ? 10 : 0, alignment: .center)
                        .padding(20)
                    })
                    .buttonStyle(DropDownButton())
                    
                    Button(action: {
                        print("share")
                        
                        withAnimation(.easeIn(duration: 0.2)) {
                            showPicker = false
                            longPress = 0
                            blur = 0
                            disableScroll = 1000
                        }
                    }, label: {
                        HStack {
                            Text("Share")
                                .foregroundColor(.white)
                            Spacer ()
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .font(.system(size:animatePicker2 ? 20 : 0))
                        }
                        .frame(maxHeight: animatePicker2 ? 10 : 0, alignment: .center)
                        .padding(20)
                    })
                    .buttonStyle(DropDownButton())
                    
                    
                    
                }
                
                VStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(Color("Grey 1"))
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    Spacer()
                    Rectangle()
                        .foregroundColor(Color("Grey 1"))
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    Spacer()
                    Rectangle()
                        .foregroundColor(Color("Grey 1"))
                        .frame(maxWidth: .infinity, maxHeight: 1)
                    Spacer()
                    
                }
            }
            .frame(maxWidth: animatePicker2 ? 250 : 0, maxHeight: animatePicker2 ? 200 : 0)
            //.background(Color("Grey 2"))
            .background(.regularMaterial)
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.35, dampingFraction: 1, blendDuration: 0)) {
                animatePicker2 = true
            }
        })

    }
    
//    struct PostDropDownView_Previews: PreviewProvider {
//        static var previews: some View {
//            PostDropDownView(spotifyAPI: SpotifyAPI())
//            
//        }
//    }
}


struct DropDownButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color("Grey 1") : .clear)
            


    }
}
