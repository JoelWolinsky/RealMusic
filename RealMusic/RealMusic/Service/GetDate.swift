//
//  GetDate.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 19/12/2022.
//

import Foundation
import SwiftUI

class GetDateModel: ObservableObject {
    
    func getDay(datePosted: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let day = dayFormatter.string(from: datePosted)
        
        return day
    }
    
    func getMonthYear(datePosted: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "MMM yyyy"
        let day = dayFormatter.string(from: datePosted)
        
        return day
    }
}
