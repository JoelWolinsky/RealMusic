//
//  Category.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 30/11/2022.
//

import Foundation

struct Category: Codable, Identifiable {
    var id = UUID()
    var name: String
    var emojis: [Emoji]
}
