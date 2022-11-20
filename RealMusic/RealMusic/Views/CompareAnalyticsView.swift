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

    
    var body: some View {
        VStack {
            Text("Compare Analytics")
            
            Text("You")
            ForEach(yourTopArtists) { artist in
                Text(artist.name)
            }
            
            Text("Friend")
                .padding(.top, 20)

            ForEach(friendTopArtists) { artist in
                Text(artist.name)
            }
            
            Button {
                analyticsModel.compareTopArtists(yourArtists: yourTopArtists, friendsArtists: friendTopArtists)
            } label: {
                Text("Compare Top Artists")
            }

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
