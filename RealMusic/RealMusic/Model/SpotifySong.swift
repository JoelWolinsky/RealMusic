//
//  SpotifySong.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 21/10/2022.
//

import Foundation

// Structure of a song returned by the Spotify API
struct SpotifySong: Identifiable, Decodable, Encodable {
    
    var id = UUID()
    var songID: String
    var title: String
    var artist: String
    var uid: String
    var cover: String
    var preview_url: String?
    
    
}
