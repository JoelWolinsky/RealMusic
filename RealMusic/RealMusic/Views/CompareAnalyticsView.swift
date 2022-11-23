////
////  CompareAnalytics.swift
////  RealMusic
////
////  Created by Joel Wolinsky on 20/11/2022.
////
//
//import Foundation
//import SwiftUI
//
//
//struct CompareAnalyticsView: View {
//    
//    
//    @ObservedObject var analyticsModel = AnalyticsModel()
//    
//    @State var yourTopArtists = [ComparisonItem]()
//    @State var friendTopArtists = [ComparisonItem]()
//    
//    @State var yourTopGenres = [ComparisonItem]()
//    @State var friendTopGenres = [ComparisonItem]()
//
//    
//    @State var yourUID = (UserDefaults.standard.value(forKey: "uid") ?? "") as! String
//    @State var friendUID: String
//
//    
//    @State var score = Double()
//    
//    @Environment(\.refresh) private var refresh
//
//  
//
//
//    
//    var body: some View {
//        VStack {
////            Text("Compare Analytics")
////            HStack {
////                VStack {
////                    Text("You")
////                    ForEach(yourTopArtists) { artist in
////                        HStack {
////                            Text("\(artist.rank ?? 0)")
////                            Text(artist.name)
////                        }
////                    }
////                }
////                VStack {
////                    Text("Friend")
////                        .padding(.top, 20)
////
////                    ForEach(friendTopArtists) { artist in
////                        HStack {
////                            Text("\(artist.rank ?? 0)")
////                            Text(artist.name)
////                        }
////
////                    }
////                }
////            }
////            Button {
////                analyticsModel.compare(yourUID: yourUID, friendUID: friendUID)
////            } label: {
////                Text("Compare")
////            }
////           Text(String(format: "Score: %.0f", analyticsModel.score))
////                .foregroundColor(.green)
////                //.onAppear(analyticsModel.getMatchScore)
//            Button("Refresh") {
//                        Task {
//                            print("Refreshing")
//                            await analyticsModel.compare(yourUID: yourUID, friendUID: friendUID)
//                            print("Refreshed")
//                        }
//                    }
//                    //.disabled(refresh == nil)
//                    .foregroundColor(.orange)
//            
////            Text(String(format: "Score: %.0f", analyticsModel.scoreModel.score))
////                 .foregroundColor(.orange)
//            
//            
////
////
//        }
//        .onAppear(perform: {
//            print("comparing \(yourUID) & \(friendUID)")
//            //analyticsModel.compare(yourUID: yourUID, friendUID: friendUID)
//        })
////        .onAppear(perform: {
////            analyticsModel.fetchTopArtistsFromDB(uid: yourUID) { rankings in
////                yourTopArtists = rankings[0]
////                yourTopGenres = rankings[1]
////            }
////            
////            analyticsModel.fetchTopArtistsFromDB(uid: friendUID) { rankings in
////                friendTopArtists = rankings[0]
////                friendTopGenres = rankings[1]
////
////            }
////
////        })
//        
//    }
//    
//}
