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
    
    static let shared = SpotifyAPI()
    
    var token = //"BQAmKq9ZZZoO53yAHDtkna8e04xPHR87Dn47uNERYOfcYZIZbDj0aonR-DBRWxaxMl097OeWtOvsWrIe4tj-qdyzvx_815aLWG6Tb8qQjI5mOyEsuegGSioh4_SZ0jrMZwSQd3qz5Asy8kw3FO3vbrrmZBEDZUkdii5tin_U4-R80Un4cFsZhsmGN4e5Rb82q5fz0i5jPYH2DQud"
    UserDefaults.standard.value(forKey: "Authorization") ?? ""
    
    
    
    func getAccessTokenURL() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.authHost
        components.path = "/authorize"
        
        components.queryItems = APIConstants.authParams.map({URLQueryItem(name: $0,value: $1)})
        
        guard let url = components.url else { return nil }
        
        print("URL ACCESS TOKEN", url)
        return URLRequest(url: url)
    }
    
    // fix this so it adds more data to the spotifysong item
    func search(input: String, completion: @escaping (Result<[SpotifySong], Error>) -> Void) {
        print("token \(token)")
        var name = "3A"
        for word in input.components(separatedBy: " ") {
            if name == "3A" {
                name = name + word
            } else {
                name = name + "%20" + word
            }
            print("name: \(name)")
        }
        
        let url = URL(string: "https://api.spotify.com/v1/search?q=track%" + name + "&type=track%2Cartist&market=ES&limit=5&offset=0")!
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
                    posts.append(SpotifySong(songID: song.id , uid: "xyz", cover: song.album.images[0].url, preview_url: song.preview_url))
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
    let preview_url: String? //Not all songs can be played back through the spotify api
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
