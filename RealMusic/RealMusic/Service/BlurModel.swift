//
//  BlurModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 28/11/2022.
//

import Foundation
import SwiftUI

class BlurModel: ObservableObject {
    
    @Published var blur: Int
    
    init(blur: Int) {
        self.blur = blur
    }
}
