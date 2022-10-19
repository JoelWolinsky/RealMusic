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
    
    func search(input: String) {
        print("fetching data")
        
        var name = "3A"
        for word in input.components(separatedBy: " ") {
            if name == "3A" {
                name = name + word
            } else {
                name = name + "%20" + word
            }
            print("name: \(name)")
        }
        
        //name = "https://api.spotify.com/v1/search?q=track%" + name + "&type=track%2Cartist&market=ES&limit=1&offset=0"
        //print(name)
        let url = URL(string: "https://api.spotify.com/v1/search?q=track%" + name + "&type=track%2Cartist&market=ES&limit=1&offset=0")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer BQA6n8R1wOiOeXfbq2CptwjD15gyAAmXaUeuvZLTPTO5VPu9CurPUVsvfakZS3VqeB8kjRrnUr_m65DOAB9N_pCqF3C3_gwtc2J1sLK3ECiIwNFcWjxFpckyF_OPzRuLsJLyL1xfJ-dwvpQCSthQCXGzsqeDQFAaXNZh2uCR44YtlPMPdMVl0S4U6dqvRVoYA80",
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
                 
            print("")
            print("")
           // print(JSONDecoder().decode(String, from: data))
            
            
            
            //print(try? data["artists"])
            

//            print(String(decoding: data, as: UTF8.self))
            if let data = data,
               let results = try? JSONDecoder().decode(Response.self, from: data) {
                    print("done")
                    print(results)
            } else {
                fatalError()
            }
            
//            let items = results.tracks.items
//            print(items)

            
    //          completionHandler(APIReturn.results ?? [])
    //            print(APIReturn)
              
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
