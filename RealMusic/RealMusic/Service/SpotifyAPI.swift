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
    
    @State var token = UserDefaults.standard.value(forKey: "authorization") ?? ""
    
    
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
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/me/player/currently-playing")!
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
            print(UserDefaults.standard.value(forKey: "authorization"))
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
            print(request.httpBody)
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
        
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
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
        
        if let url = URL(string: "https://api.spotify.com/v1/search?q=track%" + name + "&type=track%2Cartist&market=GB&limit=20&offset=0") {
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
                        posts.append(SpotifySong(songID: song.id ,title: song.album.name,artist: song.artists[0].name, uid: "xyz", cover: song.album.images[0].url, preview_url: song.preview_url))
                    }
                    //return post
                } else {
                    completion(.success([]))
                }
                
                completion(.success(posts))
                
            }
                .resume()
        }
    }
    
    
    // Given the id of a Spotify song, fins all the data on that song
    func getSong(ID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
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
    func getCurrentPlaying(completion: @escaping (Result<[SpotifySong], NetworkError>) -> Void) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
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
                print("done get song")
                print(results)
            
                let song = SpotifySong(songID: results.item.id ,title: results.item.name, artist: results.item.artists[0].name, uid: "xyz", cover: results.item.album.images[0].url, preview_url: results.item.preview_url)
                
                completion(.success([song]))
                //post = Post(songID: results.tracks.items[0].id , uid: "xyz", cover: results.tracks.items[0].album.images[0].url)
                //return post
            } else {
                print("nothing playing")
                completion(.failure(.badURL))
            }
            //completion(.failure())
            
        }
        .resume()
    }
    
    // Adds a song the the users Spotify library (i.e. likes the song for them on Spotify)
    func addToLibrary(trackID: String) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        print("123")
        let url = URL(string: "https://api.spotify.com/v1/me/tracks?ids=" + trackID)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        request.allHTTPHeaderFields = requestHeader
        print("\(url)")
        
        URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    print(response)
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
            }
        }.resume()
    }
    
    // Adds a song the users Spotify queue
    func addToQueue(trackID: String) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        print("123")
        print(trackID)
        let url = URL(string: "https://api.spotify.com/v1/me/player/queue?uri=spotify%3Atrack%3A" + trackID)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        print("\(token)")
        request.allHTTPHeaderFields = requestHeader
        print("\(url)")
        
        URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    print(response)
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
            }
        }.resume()
    }
    
    // If the user doesn't already have a 'RealMusic' plalist, it will create one for them
    func createPlaylist() {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        print("123")
        let url = URL(string: "https://api.spotify.com/v1/users/21lb3onaazabyh7d7pka5pwqi/playlists")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        print("\(token)")
        request.allHTTPHeaderFields = requestHeader
        
        let json: [String : Any] = [
            "name": "RealMusic",
            "description": "Here you can find all your favourite songs from RealMusic",
            "public": false
          ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpBody = jsonData
        
        print("\(url)")
        
        URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    print(response)
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
            }
        }.resume()
    }
    
    // Fetches the playlists in the users library until it finds 'RealMusic' or reaches the end of their library
    func getPlaylists(userSpotifyID: String, offset: Int, completion: @escaping (String) -> ()) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        print("123")
        let url = URL(string: "https://api.spotify.com/v1/users/\(userSpotifyID)/playlists?limit=50&offset=\(offset)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        print("\(token)")
        request.allHTTPHeaderFields = requestHeader
        
        print("\(url)")
        
        let playlists = URLSession.shared.dataTask(with: request) {data, response, error in
            
             if let error = error {
               print("Error with fetching films: \(error)")
               return
             }
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 print("Error with the response, unexpected status code: \(response)")
                 return
             }
            var playlists: Playlists
            if let data = data,
               let results = try? JSONDecoder().decode(Playlists.self, from: data) {
                print("done get playlists")
                print(results)
                var realmusicID = ""
                
                if results.items.isEmpty {
                    completion("no playlist found")
                }
                
                for playlist in results.items {
                    if playlist.name == "RealMusic" {
                        realmusicID = playlist.id
                    }
                }
                
                if realmusicID == "" {
                    print("recursion")
                    self.getPlaylists(userSpotifyID: userSpotifyID, offset: offset + 50) { (playlistID) in
                      completion(playlistID)
                    }
                } else {
                    print("found playlist and returning")
                    completion(realmusicID)
                }
                
            } else {
                print("nothing playing")
                completion("")
            }
        }
        .resume()
    }
    
    func addToPlaylist(playlistID: String, trackID: String) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        print("123")
        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistID)/tracks?position=0&uris=spotify%3Atrack%3A\(trackID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        print("\(token)")
        request.allHTTPHeaderFields = requestHeader
        
        print("\(url)")
        
        URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            print("Adding song to playlist")
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    print(response)
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
            }
        }.resume()
    }
    
    
    func getUserID(completion: @escaping (Result<String, NetworkError>) -> Void) {
        token = UserDefaults.standard.value(forKey: "authorization") ?? ""
        print("123")
        let url = URL(string: "https://api.spotify.com/v1/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        print("\(token)")
        request.allHTTPHeaderFields = requestHeader
        
        print("\(url)")
        
        let playlists = URLSession.shared.dataTask(with: request) {data, response, error in
            
             if let error = error {
               print("Error with fetching films: \(error)")
               return
             }
             
             guard let httpResponse = response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) else {
                 print("Error with the response, unexpected status code: \(response)")
                 return
             }
            if let data = data,
               let results = try? JSONDecoder().decode(SpotifyUser.self, from: data) {
                print("done get user id")
                print(results)
                
                completion(.success(results.id))
                //post = Post(songID: results.tracks.items[0].id , uid: "xyz", cover: results.tracks.items[0].album.images[0].url)
                //return post
            } else {
                print("failed to code id")
                completion(.failure(.badURL))
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
    let id: String
}

struct Album2: Codable {
    let name: String
    let images: [AlbumImage]
}

struct AlbumImage: Codable {
    let height: Int
    let url: String
}

enum NetworkError: Error {
    case badURL
}

struct Playlists: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let id: String
    let name: String
    
}

struct SpotifyUser: Codable {
    let display_name: String
    let id: String
}
