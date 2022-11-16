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
    
    let album: Album

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: album.cover)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(2)
                    .padding(20)
            } placeholder: {
                Color.orange
            }
            VStack {
                Text(album.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(20)
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                
                Text(album.artist)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(20)
                    .padding(.top, -40)
                    .foregroundColor(Color("Grey"))
                    .font(.system(size: 15))
            }
            
            

           
        }
        .background(Color("Dark Grey"))
        //.scaledToFill()
        .cornerRadius(10)
   
    }
        
    
    struct CurrentlyPlayingView_Previews: PreviewProvider {
        static var previews: some View {
            CurrentlyPlayingView(album: Album(title: "Goodie Bag", artist: "Still Woozy" , cover: "https://i.scdn.co/image/ab67616d00004851d52e14e0595216ca453572ab", preview: ""))
        }
    }
}

