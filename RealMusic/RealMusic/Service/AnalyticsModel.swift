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
        let url = URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=long_term&limit=5&offset=0")!
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
            var rating = 0
            for artist in artists.items {
                try db.collection("Users").document(uid).collection("Spotify Analytics").document("Top Artists").collection("Top Artists").document(String(rating)).setData(from: artist)
                rating += 1
                print("\(artist.name) added")
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
                    guard let artist = try? artist.data(as: TopArtist.self) else { return }
                    artists.append(artist)
                }
                completion(artists)
            }
    }
    
    func compareTopArtists(yourArtists: [TopArtist], friendsArtists: [TopArtist]) {
        var yourArtistRank = 1
        var friendsArtistRank = 1
        
        var comparisonValue = 0
        
        for yourArtist in yourArtists {
            for friendsArtist in friendsArtists {
                if yourArtist.id == friendsArtist.id {
                    print("true \(friendsArtist.name)")
                    comparisonValue += (9-abs(friendsArtistRank-yourArtistRank)) * 100 + 100*(5-yourArtistRank)
                }
            }
        }
        
        print(comparisonValue)
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
    
}



