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
            "Authorization" : "Bearer BQB9T8ZH_JfbaLFz28aLsu8oBvLAtYgDnKH7Hm0j1h-gK3hr_EHBYo45TDPXKO48j3H_lAPzsf9g34V9gLwB5e83vxdDbL0x4oVl942deRLSMQA4FAMVt37AtbW-KVZGUfw8fUP_LEJLyYch8mnprtS5nZCGh3tx7P7vA9TAeCriUhC_tuGtfphr4PdATAQMyQA",
            "Content-Type" : "application/json"
        ]
        
        request.allHTTPHeaderFields = requestHeader

        URLSession.shared.dataTask(with: request) { data, response, error in
            print("Fetch 2")
            print(response)
            print(data)
            print(error)
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
            
            
            //print(String(decoding: data, as: UTF8.self))
            
            //print(try? data["artists"])
            
            guard let data = try? Data(contentsOf: url) else {
                        fatalError("Failed to load  from bundle.")
                    }
           
            guard let APIReturn = try? JSONDecoder().decode(Response.self, from: data) else {
                fatalError("Failed to decode  from bundle.")
            }
            
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
}
