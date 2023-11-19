//
//  EmojiPickerCoverView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 06/12/2022.
//

import Foundation
import SwiftUI

struct EmojiPickerCoverView: View {
    @State var cover: String
    @State private var animateCover = false

    var body: some View {
        VStack {
            if let url = URL(string: cover ?? "") {
                CacheAsyncImage(url: url) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(animateCover ? 1 : 0)
                    case let .failure(error):
                        Text("fail")
                    case .empty:
                        Rectangle()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(20)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: animateCover ? 150 : 500, height: animateCover ? 150 : 500)
            }
        }
        .frame(maxWidth: 150, maxHeight: 150)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.35, dampingFraction: 1, blendDuration: 0)) {
                animateCover = true
            }
        })
    }
}
