//
//  SpotifyAPI.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 19/10/2022.
//

import Foundation
import SwiftUI


enum APIError : Error {
    case  expiredToken
}
// Handle all interactions with the Spotify API
class SpotifyAPI: ObservableObject {
    //@Published var response = Response
    
    static let shared = SpotifyAPI()
    
    @State var token = UserDefaults.standard.value(forKey: "Authorization") ?? ""
    
    
    // Gets they URL for authorizing the user to get a Spotify access token
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
    
    // Check the Spotify access token is still valid
    func checkTokenExpiry(completion: @escaping (Bool) -> Void) {
        
        let url = URL(string: "https://api.spotify.com/v1/search?q=track%3Atest&type=track%2Cartist&market=GB&limit=1&offset=0")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            //"Authorization" : "Bearer fdsafsad",
            "Content-Type" : "application/json"
        ]
        request.allHTTPHeaderFields = requestHeader
        
        print("Bearer check \(token)")
        
        
        
        _ = URLSession.shared.dataTask(with: request) {data, response, error in
            
            print("url session")
            print(data)
            print(UserDefaults.standard.value(forKey: "Authorization"))
            print(request.allHTTPHeaderFields)
             if let error = error {
               print("Error with fetching films: \(error)")
               completion(false)
               return
             }
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 print("Error with the response, unexpected status code: \(response)")
                 completion(false)
                 return
             }
            print("url session no error")
            print("response \(response)")
            completion(true)
                //completion(.success([results.name, artists]))
                //post = Post(songID: results.tracks.items[0].id , uid: "xyz", cover: results.tracks.items[0].album.images[0].url)
                //return post
            
            //completion(.failure())
            
        }
        .resume()
        
    }
    
    // Given a song name or part of a name, return song results matching that name
    // fix this so it adds more data to the spotifysong item
    func search(input: String, completion: @escaping (Result<[SpotifySong], Error>) -> Void) {
        
        token = UserDefaults.standard.value(forKey: "Authorization") ?? ""
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
        print("Bearer \(token)")

        let post = URLSession.shared.dataTask(with: request) {data, response, error in
             if let error = error {
               print("Error with fetching films: \(error)")
               return
             }
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 print("Error with the response, unexpected status code: \(response)")
                 completion(.failure(APIError.expiredToken))
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
    
    
    // Given the id of a Spotify song, fins all the data on that song
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
    
    // Get current playing song
    func getCurrentPlaying(completion: @escaping (Result<[Item], Error>) -> Void){
        print("get current playing song")
        let url = URL(string: "https://api.spotify.com/v1/me/player/currently-playing")!
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
               let results = try? JSONDecoder().decode(CurrentPlay.self, from: data) {
                    print("done")
                    print(results)
                
                completion(.success([results.item]))
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

struct CurrentPlay: Codable {
    let item: Item
}

struct Item: Codable {
    let name: String
    let artists: [Artist]
    let id: String
    let album: Album2
    let preview_url: String? //Not all songs can be played back through the spotify api, this will need to be handled
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
