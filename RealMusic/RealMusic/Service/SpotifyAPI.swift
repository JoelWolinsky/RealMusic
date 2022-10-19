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
    
    func fetchData() {
        print("fetching data")
        let url = URL(string: "https://api.spotify.com/v1/search?q=track%3ALet%20It%20Go&type=track%2Cartist&market=ES&limit=2&offset=5")!
        
//        guard let url = urlBuilder?.url else { return }
//
//        print(url)
//
//
//        var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.setValue("Authorization", forHTTPHeaderField: "Bearer BQAFFvK_66_0IQhFPJ6Re5O6KgyCFhzGoKHJ_KKKr-sYW6CXzP4h3F8IbtRjaP2W-gnbB1dDZmRS3ToNolgMku5mAGCst7LV1PAFJyhdtj-08nHFDBpmN-Dqo3c-UCQXi0ukLMsW7tHDGXQaQIdtB204pLSOzn9E-OjUIxab0pQi0VdcVk8szNvvA65D55WAGa8")
//            request.setValue("Content-Type", forHTTPHeaderField: "application/json")
//
//
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                print(response)
//                print(data)
//                print(error)
//                //print(String(data: data, encoding: .utf8)) //Try this too!
//            }.resume()
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let requestHeader:  [String : String] = [
            "Authorization" : "Bearer BQCskbVY4OuQ2Bu-sNIB_zUQ6eLE_DvkpIJkAvaUlhwdLCFERYBI1B8yBbTGP-1LU1c4ZYSBs5FrW3cszC2_1QNoqH37PnWafUPjwul6VrXm_pSlMxKM5vJ5fYFcJn6_9n-cfeffOW2nXl4PuJzfgSmH2Zu39AQtz4WSudZNURzrbmN6Xs3j3yZyqcTQhzdP9Uo",
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
}

struct Artist: Codable {
    let name: String
}
