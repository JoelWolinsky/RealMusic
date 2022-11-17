//
//  Extensions.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 16/11/2022.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .leading))}
}
