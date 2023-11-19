//
//  SpotifyAPI.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 19/10/2022.
//

import Foundation
import SwiftUI

enum APIError: Error {
    case expiredToken
}

// Handle all interactions with the Spotify API
class SpotifyAPI: ObservableObject {
    static let shared = SpotifyAPI()
    @State var token = UserDefaults.standard.value(forKey: "auth") ?? ""

    // Gets they URL for authorizing the user to get a Spotify access token
    func getAccessTokenURL() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.authHost
        components.path = "/authorize"
        components.queryItems = APIConstants.authParams.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }

    // Check the Spotify access token is still valid
    func checkTokenExpiry(completion: @escaping (Bool) -> Void) {
        let token = UserDefaults.standard.string(forKey: "auth") ?? "no token yet"
        let url = URL(string: "https://api.spotify.com/v1/me/player/currently-playing")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader

        _ = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(false)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                completion(false)
                return
            }
            completion(true)
        }
        .resume()
    }

    // Given a song name or part of a name, return song results matching that name
    // fix this so it adds more data to the spotifysong item
    func search(input: String, completion: @escaping (Result<[SpotifySong], Error>) -> Void) {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        var name = "3A"
        for word in input.components(separatedBy: " ") {
            if name == "3A" {
                name = name + word
            } else {
                name = name + "%20" + word
            }
        }

        if let url = URL(string: "https://api.spotify.com/v1/search?q=track%" + name + "&type=track%2Cartist&market=GB&limit=20&offset=0") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let requestHeader: [String: String] = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
            request.allHTTPHeaderFields = requestHeader

            let post = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ... 299).contains(httpResponse.statusCode)
                else {
                    completion(.failure(APIError.expiredToken))
                    return
                }
                var posts: [SpotifySong] = []
                if let data = data,
                   let results = try? JSONDecoder().decode(Response.self, from: data)
                {
                    for song in results.tracks.items {
                        posts.append(SpotifySong(songID: song.id, title: song.album.name, artist: song.artists[0].name, uid: "xyz", cover: song.album.images[0].url, preview_url: song.preview_url))
                    }
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
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/tracks/" + ID)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader

        let post = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                return
            }
            var post: Post
            if let data = data,
               let results = try? JSONDecoder().decode(Item.self, from: data)
            {
                var artists = ""
                for artist in results.artists {
                    if artists == "" {
                        artists += artist.name
                    } else {
                        artists += ", " + artist.name
                    }
                }
                completion(.success([results.name, artists]))
            } else {
                fatalError()
            }
        }
        .resume()
    }

    // Get current playing song
    func getCurrentPlaying(completion: @escaping (Result<[SpotifySong], NetworkError>) -> Void) {
        // Very important that I am using 'let' here since before it was taking the global value which didn't update with the new token
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/me/player/currently-playing")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader

        let post = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                return
            }
            var post: Post
            if let data = data,
               let results = try? JSONDecoder().decode(CurrentPlay.self, from: data)
            {
                let song = SpotifySong(songID: results.item.id, title: results.item.name, artist: results.item.artists[0].name, uid: "xyz", cover: results.item.album.images[0].url, preview_url: results.item.preview_url)
                completion(.success([song]))
            } else {
                completion(.failure(.badURL))
            }
        }
        .resume()
    }

    // Adds a song the the users Spotify library (i.e. likes the song for them on Spotify)
    func addToLibrary(trackID: String) {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/me/tracks?ids=" + trackID)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    return
                }
            }
        }.resume()
    }

    // Adds a song the users Spotify queue
    func addToQueue(trackID: String) {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/me/player/queue?uri=spotify%3Atrack%3A" + trackID)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                return
            }

            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    return
                }
            }
        }.resume()
    }

    // If the user doesn't already have a 'RealMusic' plalist, it will create one for them
    func createPlaylist() {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/users/21lb3onaazabyh7d7pka5pwqi/playlists")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader
        let json: [String: Any] = [
            "name": "RealMusic",
            "description": "Here you can find all your favourite songs from RealMusic",
            "public": false,
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    return
                }
            }
        }.resume()
    }

    // Fetches the playlists in the users library until it finds 'RealMusic' or reaches the end of their library
    func getPlaylists(userSpotifyID: String, offset: Int, completion: @escaping (String) -> Void) {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/users/\(userSpotifyID)/playlists?limit=50&offset=\(offset)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader
        let playlists = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                return
            }
            var playlists: Playlists
            if let data = data,
               let results = try? JSONDecoder().decode(Playlists.self, from: data)
            {
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
                    self.getPlaylists(userSpotifyID: userSpotifyID, offset: offset + 50) { playlistID in
                        completion(playlistID)
                    }
                } else {
                    completion(realmusicID)
                }

            } else {
                completion("")
            }
        }
        .resume()
    }

    func addToPlaylist(playlistID: String, trackID: String) {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistID)/tracks?position=0&uris=spotify%3Atrack%3A\(trackID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader

        URLSession.shared.dataTask(with: request) { responseData, response, error in
            if let error = error {
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    return
                }
            }
        }.resume()
    }

    func getUserID(completion: @escaping (Result<String, NetworkError>) -> Void) {
        let token = UserDefaults.standard.value(forKey: "auth") ?? ""
        let url = URL(string: "https://api.spotify.com/v1/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        request.allHTTPHeaderFields = requestHeader

        let playlists = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                return
            }
            if let data = data,
               let results = try? JSONDecoder().decode(SpotifyUser.self, from: data)
            {
                completion(.success(results.id))
            } else {
                completion(.failure(.badURL))
            }
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
    let preview_url: String? // Not all songs can be played back through the spotify api, this will need to be handled
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
