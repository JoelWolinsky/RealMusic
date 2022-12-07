//
//  ReactionViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 28/11/2022.
//

import Foundation
import SwiftUI

class ReactionViewModel: ObservableObject {
    
    var reactions = [Emoji]()
    //{
//        willSet {
//                    print("object will change")
//                    objectWillChange.send()
//                }
//    }
    var distinctReactions = [Emoji]() {
        willSet {
            if !distinctReactions.isEmpty {
                print("object will change d \(distinctReactions)")
                objectWillChange.send()
            }
                }
    }
    
    @ObservedObject var feedViewModel = FeedViewModel()
        
    var id: String
    
    
    init(id: String) {
        self.id = id
        fetchReactions(id: id)
    }
    
    func fetchReactions(id: String) {
        self.reactions = []
//self.distinctReactions = []
        print("fetching reactions ")
        feedViewModel.fetchReactions(postUID: id) { result in
            self.reactions = result
            self.calculateDistinctReactions()

        }
        
    }
    
    func addLocalReaction(reaction: Emoji) {
        //let reaction = Emoji(emoji: "🍅", name: "")
        //self.reactions.append(reaction)
        
        //self.calculateDistinctReactions()
        fetchReactions(id: self.id)
    }
    
    func calculateDistinctReactions() {
        print("calculate distinct for \(self.reactions.count)")
        var distinct = [Emoji]()
        var duplicate = false
        
        // Limit the number of reactions that can show in the view
        var limit = 5
        var reactionCounter = 0
        for reaction in self.reactions {
            if reactionCounter <= limit {
                for distinctReaction in distinct {
                    if distinctReaction.emoji == reaction.emoji {
                        duplicate = true
                    }
                }
                if duplicate == false {
                    distinct.append(reaction)
                }
            }
            duplicate = false
        }
        print("number of distinct reactions: \(distinct.count)")
        self.distinctReactions = distinct
    }
}


