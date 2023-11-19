//
//  ReactionsView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import SwiftUI

struct ReactionsView: View {
    @StateObject var reactionViewModel: ReactionViewModel
    var post: Post
    @State var emojiSize: CGFloat

    var body: some View {
        HStack {
            ForEach(reactionViewModel.distinctReactions) { emoji in
                if emoji.docID == "\(UserDefaults.standard.value(forKey: "uid") ?? "")" {
                    Text(emoji.emoji)
                        .font(.system(size: emojiSize))
                } else {
                    Text(emoji.emoji)
                        .font(.system(size: emojiSize))
                        .onAppear(perform: {
                        })
                }
            }
            if reactionViewModel.distinctReactions.count != reactionViewModel.reactions.count {
                Text(String(reactionViewModel.reactions.count))
                    .foregroundColor(.white)
            }
        }
        .frame(minWidth: reactionViewModel.distinctReactions.isEmpty ? 0 : 20)
        .padding(reactionViewModel.distinctReactions.isEmpty ? 0 : emojiSize / 2)
        .background(Color("Grey 3"))
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black, lineWidth: 5)
        )
        .cornerRadius(40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onReceive(reactionViewModel.objectWillChange, perform: {
            let temp = emojiSize
            if !reactionViewModel.reactions.isEmpty {
                emojiSize = 2.0
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                    emojiSize = temp
                }
            }
        })
    }
}
