//
//  SearchResultView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/10/2022.
//

import Foundation
import SwiftUI

struct SearchResultView: View {
    
    @State var song: SpotifySong
    
    @ObservedObject var spotifyAPI = SpotifyAPI()

    
    var body: some View {
        Text(song.songID)
        Text(song.title ?? "placeholder")
            .onAppear(perform: {print("songid \(song.songID)");
                spotifyAPI.getSong(ID: song.songID ?? "") { (result) in
                switch result {
                    case .success(let data) :
                    print("success \(data)")
                    song.title = data[0]

                    case .failure(let error) :
                        print()
                    }
                }
            })
    }
    
}

