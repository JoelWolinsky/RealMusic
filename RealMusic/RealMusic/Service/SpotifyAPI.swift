//
//  SpotifyAPI.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 19/10/2022.
//

import Foundation
import SwiftUI

class SpotifyAPI: ObservableObject {
    //@Published var response = Response
    
    var token = "BQC6FJhmDfAWCErY1QWbt6VXwFM0wzOxZTzdMd_4kjkshLW0eWDEF3mm7psInz4WVksD02kzhHyDAqyvBCHJWmGEhyqXiKOgviM71OsEOO6xoiy_0ICuo10GBU3-LqyqaXtE3u3twsIqcaizac-FKAZ0P2o49JzvzZI98V86IVTEhkYS6saaBY1A1QsPPRu47Uc"
    
    func search(input: String, completion: @escaping (Result<[SpotifySong], Error>) -> Void) {
        var name = "3A"
        for word in input.components(separatedBy: " ") {
            if name == "3A" {
                name = name + word
            } else {
                name = name + "%20" + word
            }
            print("name: \(name)")
        }
        
        let url = URL(string: "https://api.spotify.com/v1/search?q=track%" + name + "&type=track%2Cartist&market=ES&limit=2&offset=0")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        request.allHTTPHeaderFields = requestHeader

        let post = URLSession.shared.dataTask(with: request) {data, response, error in
             if let error = error {
               print("Error with fetching films: \(error)")
               return
             }
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 print("Error with the response, unexpected status code: \(response)")
                 return
             }
            var posts: [SpotifySong] = []
            if let data = data,
               let results = try? JSONDecoder().decode(Response.self, from: data) {
                    print("done")
                    print(results)
                for song in results.tracks.items {
                    print("adding song to search list")
                    posts.append(SpotifySong(songID: song.id , uid: "xyz", cover: song.album.images[0].url))
                }
                //return post
            } else {
                fatalError()
            }
            completion(.success(posts))
            
        }
        .resume()
    }
    
    
    func getSong(ID: String, completion: @escaping (Result<[String], Error>) -> Void){
        
        
        let url = URL(string: "https://api.spotify.com/v1/tracks/" + ID)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        request.allHTTPHeaderFields = requestHeader

        let post = URLSession.shared.dataTask(with: request) {data, response, error in
             if let error = error {
               print("Error with fetching films: \(error)")
               return
             }
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 print("Error with the response, unexpected status code: \(response)")
                 return
             }
            var post: Post
            if let data = data,
               let results = try? JSONDecoder().decode(Item.self, from: data) {
                    print("done")
                    print(results)
                var artists = ""
                for artist in results.artists {
                    if artists == "" {
                        artists += artist.name
                    } else {
                        artists += ", " + artist.name
                    }
                }
                completion(.success([results.name, artists]))
                //post = Post(songID: results.tracks.items[0].id , uid: "xyz", cover: results.tracks.items[0].album.images[0].url)
                //return post
            } else {
                fatalError()
            }
            //completion(.failure())
            
        }
        .resume()
    }
    
}



struct Response: Codable {
    let tracks: Track
}

struct Track: Codable {
    let items: [Item]
}

struct Item: Codable {
    let name: String
    let artists: [Artist]
    let id: String
    let album: Album2
}

struct Artist: Codable {
    let name: String
}

struct Album2: Codable {
    let name: String
    let images: [AlbumImage]
}

struct AlbumImage: Codable {
    let height: Int
    let url: String
}
