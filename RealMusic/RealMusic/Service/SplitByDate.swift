//
//  SplitByDate.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 19/12/2022.
//

import Foundation

struct SplitByDate {
    let sections: [Month]
    
    init(posts: [Post]) {
        // create some events
        //        let first = Occurrence(start: EventData.constructDate(day: 5, month: 5, year: 2019), title: "First Event")
        //        let second = Occurrence(start: EventData.constructDate(day: 5, month: 5, year: 2019, hour: 10), title: "Second Event")
        //        let third = Occurrence(start: EventData.constructDate(day: 5, month: 6, year: 2019), title: "Third Event")
        //
        //        // Create an array of the occurrence objects and then sort them
        //        // this makes sure that they are in ascending date order
        //        let events = [third, first, second].sorted { $0.start < $1.start }
        
        let events = posts
        
        // create a DateFormatter
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MMM yyyy"
        
        // We use the Dictionary(grouping:) function so that all the events are
        // group together, one downside of this is that the Dictionary keys may
        // not be in order that we require, but we can fix that
        let grouped = Dictionary(grouping: events) { (post: Post) -> String in
            dateFormatter.string(from: post.datePosted)
        }
        
        // We now map over the dictionary and create our Day objects
        // making sure to sort them on the date of the first object in the occurrences array
        // You may want a protection for the date value but it would be
        // unlikely that the occurrences array would be empty (but you never know)
        // Then we want to sort them so that they are in the correct order
        self.sections = grouped.map { month -> Month in
            Month(title: month.key, occurrences: month.value, date: month.value[0].datePosted)
        }.sorted { $0.date > $1.date }
        
        print("number of sections \(sections.count)")
    }
}

struct Month: Identifiable {
    let id = UUID()
    let title: String
    let occurrences: [Post]
    let date: Date
}
