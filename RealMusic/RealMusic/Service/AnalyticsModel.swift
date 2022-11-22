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
    
    @Published var score = Double()
    
    //@ObservedObject var scoreModel = ScoreModel()

    func fetchTopArtistsFromAPI(completion: @escaping (Result<[ComparisonItem], Error>) -> Void)  {
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
                var artists = [ComparisonItem]()
                for artist in results.items {
                    artists.append(artist)
                }
                completion(.success(artists))
            } else {
                fatalError()
            }
        }
        .resume()
    }
    
    func uploadToDB(items: [ComparisonItem], rankingType: String ) {

        let db = Firestore.firestore()
        
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        //let post = Post(title: "Test Send Post", uid: "test uid")

        do {
            var rank = 1
            for item in items {
                if rankingType == "Top Artists" {
                    let item = ComparisonItem(name: item.name, id: item.id!, popularity: item.popularity!, genres: item.genres!, rank: rank)
                } else {
                    let item = ComparisonItem(name: item.name, rank: rank)

                }
                try db.collection("Users").document(uid).collection("Spotify Analytics").document(rankingType).collection(rankingType).document(String(rank)).setData(from: item)
                print("\(item.name) added as \(rank)")
                rank += 1
            }
           
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func fetchTopArtistsFromDB(uid id: String, completion: @escaping (Result<[[ComparisonItem]], Error>) -> Void ) {
        var artists = [ComparisonItem]()
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
                    guard let artist = try? artist.data(as: ComparisonItem.self) else { return }
                    artists.append(artist)
                }
                artists.sort {
                    $0.rank ?? 0 < $1.rank ?? 0
                }
                print("get genres")
                let genres = self.getTopGenres(topArtists: artists)
                completion(.success([artists, genres]))
            }
    }
    
    func getTopGenres(topArtists: [ComparisonItem]) -> [ComparisonItem]{
        
        var genres = [ComparisonItem]()
        var rank = 1
        
        for artist in topArtists {
            for genre in artist.genres! {
                genres.append(ComparisonItem(name: genre, rank: rank))
                print("\(rank) \(genre)")
                rank += 1
            }
        }
        return genres
    }
    
    func compareRankings(yourRanking: [ComparisonItem], friendRanking: [ComparisonItem]) -> Double {
        var yourRank = 1.0
        var friendRank = 1.0
        
        let rankingLength = Double(yourRanking.count)
        
        var totalScore = 0.0
        
        var distanceApartScore = Double()
        var distanceFromTopScore = Double()
        var popularityScore = Double()

        
        for yourItem in yourRanking {
            friendRank = 1
            for friendItem in friendRanking {
                if yourItem.name == friendItem.name { // look into this since there can be duplicate names
                    // calculates how valuable the match is
                    // based of how close common artist is on their leaderboards
                    distanceApartScore = ((rankingLength*1.5)-Double(abs(friendRank-yourRank))) * 100.0
                    // and how high up they are on these leaderboards
                    distanceFromTopScore = ((rankingLength * 2)-yourRank-friendRank) * 25.0
                    if yourItem.popularity != nil {
                        popularityScore = (100 - Double(yourItem.popularity!)) * 50.0
                        totalScore += distanceApartScore + distanceFromTopScore + popularityScore
                        print("\(yourItem.name) - \( distanceApartScore + distanceFromTopScore + popularityScore)")
                    } else {
                        totalScore += distanceApartScore + distanceFromTopScore
                        print("\(yourItem.name) - \(distanceApartScore + distanceFromTopScore)")
                    }
                }
                friendRank += 1
            }
            yourRank += 1
        }
        
        print(totalScore)
        return totalScore
    }
    
    func compare(yourUID: String, friendUID: String) {
        var yourRankings = [[ComparisonItem]]()
        var friendRankings = [[ComparisonItem]]()

        self.fetchTopArtistsFromDB(uid: yourUID) { (rankings) in
            switch rankings {
            case .success(let data):
                print(data)
                yourRankings = data
                
                self.fetchTopArtistsFromDB(uid: friendUID) { (rankings) in
                    switch rankings {
                    case .success(let data):
                        print(data)
                        friendRankings = data
                        let artistScore = self.compareRankings(yourRanking: yourRankings[0], friendRanking: friendRankings[0])
                        let genreScore = self.compareRankings(yourRanking: yourRankings[1], friendRanking: friendRankings[1])
                        let totalScore = artistScore + genreScore
                        self.score = totalScore/1000
                        
                        //self.scoreModel.score = totalScore
                        print("setting score as \(totalScore)")
                        
                    case .failure(let error):
                        print(error)
                        
                    }
                    
        //            print(rankings[0])
                }
            case .failure(let error):
                print(error)
                
            }
            
//            print(rankings[0])
        }
        
//        self.fetchTopArtistsFromDB(uid: friendUID) { rankings in
//            friendRankings = rankings
//        }
//
//        let artistScore = self.compareRankings(yourRanking: yourRankings[0], friendRanking: friendRankings[0])
//        let genreScore = self.compareRankings(yourRanking: yourRankings[1], friendRanking: friendRankings[1])
////
////        let totalScore = artistScore + genreScore
////
////        return totalScore
//        return 0.0

    }
    
}

struct TopArtists: Codable {
    let items: [ComparisonItem]
}


// This can either be an Artist or a Genre
struct ComparisonItem: Codable, Identifiable {
    let name: String
    var id: String?
    var popularity: Int?
    var genres: [String]?
    let rank: Int?
    
//    init(name: String, rank: Int) {
//        self.name = name
//        self.rank = rank
//    }
//
//    init(name: String, id: String, popularity: Int, genres: [String], rank: Int) {
//        self.name = name
//        self.id = id
//        self.popularity = popularity
//        self.genres = genres
//        self.rank = rank
//    }
    
}

//struct Genre: Codable {
//    let name: String
//    let rank: Int
//}



