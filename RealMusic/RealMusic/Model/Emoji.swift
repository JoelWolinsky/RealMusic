//
//  Emoji.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation

struct Emoji: Identifiable, Encodable, Decodable {
  let id = UUID()
  let emoji: String
  let name: String
}
