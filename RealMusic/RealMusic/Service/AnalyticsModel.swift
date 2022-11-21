//
//  AnalyticsModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class AnalyticsModel: ObservableObject {
    
    @State var token = UserDefaults.standard.value(forKey: "Authorization") ?? ""

    func fetchTopArtistsFromAPI(completion: @escaping (Result<TopArtists, Error>) -> Void)  {
        let url = URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=long_term&limit=20&offset=0")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer \(token)",
            "Content-Type" : "application/json"
        ]
        request.allHTTPHeaderFields = requestHeader
        URLSession.shared.dataTask(with: request) {data, response, error in
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
               let results = try? JSONDecoder().decode(TopArtists.self, from: data) {
                    print("done")
                completion(.success(results))
            } else {
                fatalError()
            }
        }
        .resume()
    }
    
    func uploadTopArtistsToDB(artists: TopArtists) {

        let db = Firestore.firestore()
        
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        //let post = Post(title: "Test Send Post", uid: "test uid")

        do {
            var rank = 1
            for artist in artists.items {
                let artist = TopArtist(name: artist.name, id: artist.id, popularity: artist.popularity, genres: artist.genres, rank: rank)
                try db.collection("Users").document(uid).collection("Spotify Analytics").document("Top Artists").collection("Top Artists").document(String(rank)).setData(from: artist)
                print("\(artist.name) added as \(rank)")
                rank += 1
            }
           
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func fetchTopArtistsFromDB(uid id: String, completion: @escaping([TopArtist]) -> Void ) {
        var artists = [TopArtist]()
        let db = Firestore.firestore()
        
        //let id = UserDefaults.standard.value(forKey: "uid") as! String
        
        db.collection("Users")
            .document(id)
            .collection("Spotify Analytics")
            .document("Top Artists")
            .collection("Top Artists")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else { return }
                documents.forEach{ artist in
                    let rank = artist.documentID
                    guard let artist = try? artist.data(as: TopArtist.self) else { return }
                    artists.append(artist)
                }
                artists.sort {
                    $0.rank ?? 0 < $1.rank ?? 0
                }
                self.getTopGenres(topArtists: artists)
                completion(artists)
            }
    }
    
    func getTopGenres(topArtists: [TopArtist]) {
        var genres = [Genre]()
        
        for artist in topArtists {
            for genre in artist.genres {
                genres.append(Genre(name: genre, rank: artist.rank ?? 0))
                print("\(artist.rank) \(genre)")
            }
        }
        
    }
    
    func compareTopArtists(yourArtists: [TopArtist], friendsArtists: [TopArtist]) -> Double {
        var yourArtistRank = 1.0
        var friendsArtistRank = 1.0
        
        var topArtistsLength = Double(yourArtists.count)
        
        var totalScore = 0.0
        
        var distanceApartScore = Double()
        var distanceFromTopScore = Double()
        var popularityScore = Double()

        
        for yourArtist in yourArtists {
            friendsArtistRank = 1
            for friendsArtist in friendsArtists {
                if yourArtist.id == friendsArtist.id {
                    // calculates how valuable the match is
                    // based of how close common artist is on their leaderboards
                    distanceApartScore = ((topArtistsLength*1.5)-Double(abs(friendsArtistRank-yourArtistRank))) * 100.0
                    // and how high up they are on these leaderboards
                    distanceFromTopScore = ((topArtistsLength * 2)-yourArtistRank-friendsArtistRank) * 25.0
                    popularityScore = (100 - Double(yourArtist.popularity)) * 50.0
                    totalScore += distanceApartScore + distanceFromTopScore + popularityScore
                    print("\(yourArtist.name) - \( distanceApartScore + distanceFromTopScore + popularityScore)")
                }
                friendsArtistRank += 1
            }
            yourArtistRank += 1
        }
        
        print(totalScore)
        return totalScore
    }
    
    func compareTopGenres(yourGenres: [Genre], friendsGenres: [Genre]) -> Double {
        var yourGenretRank = 1.0
        var friendsGenretRank = 1.0
        
        var topGenresLength = Double(yourArtists.count)
        
        var totalScore = 0.0
        
        var distanceApartScore = Double()
        var distanceFromTopScore = Double()

        
        for yourGenre in yourGenres {
            friendsGenreRank = 1
            for friendsGenre in friendsGenres {
                if yourGenre.name == friendsGenre.name {
                    // calculates how valuable the match is
                    // based of how close common artist is on their leaderboards
                    distanceApartScore = ((topGenresLength*1.5)-Double(abs(friendsArtistRank-yourArtistRank))) * 100.0
                    // and how high up they are on these leaderboards
                    distanceFromTopScore = ((topArtistsLength * 2)-yourArtistRank-friendsArtistRank) * 25.0
                    totalScore += distanceApartScore + distanceFromTopScore
                    print("\(yourArtist.name) - \( distanceApartScore + distanceFromTopScore)")
                }
                friendsArtistRank += 1
            }
            yourArtistRank += 1
        }
        
        print(totalScore)
        return totalScore
    }

    
    
}

struct TopArtists: Codable {
    let items: [TopArtist]
}

struct TopArtist: Codable, Identifiable {
    let name: String
    let id: String
    let popularity: Int
    let genres: [String]
    let rank: Int?
    
}

struct Genre: Codable {
    let name: String
    let rank: Int
}



