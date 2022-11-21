//
//  CompareAnalytics.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import Foundation
import SwiftUI


struct CompareAnalyticsView: View {
    
    var friendID: String
    
    @ObservedObject var analyticsModel = AnalyticsModel()
    
    @State var yourTopArtists = [TopArtist]()
    @State var friendTopArtists = [TopArtist]()

    
    @State var yourUID = (UserDefaults.standard.value(forKey: "uid") ?? "") as! String
    
    @State var score = Double()

    
    var body: some View {
        VStack {
            Text("Compare Analytics")
            HStack {
                VStack {
                    Text("You")
                    ForEach(yourTopArtists) { artist in
                        HStack {
                            Text("\(artist.rank ?? 0)")
                            Text(artist.name)
                        }
                    }
                }
                VStack {
                    Text("Friend")
                        .padding(.top, 20)
                    
                    ForEach(friendTopArtists) { artist in
                        HStack {
                            Text("\(artist.rank ?? 0)")
                            Text(artist.name)
                        }
                        
                    }
                }
            }
            Button {
                score = analyticsModel.compareTopArtists(yourArtists: yourTopArtists, friendsArtists: friendTopArtists)
            } label: {
                Text("Compare Top Artists")
            }
            
            Text(String(format: "score: %.0f", score))

        }
        .background(.white)
        .onAppear(perform: {
            analyticsModel.fetchTopArtistsFromDB(uid: yourUID) { artists in
                yourTopArtists = artists
            }
            
            analyticsModel.fetchTopArtistsFromDB(uid: friendID) { artists in
                friendTopArtists = artists
            }

        })
        
    }
    
}
