//
//  EmojiLibrayView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 29/11/2022.
//

import Foundation
import SwiftUI

struct EmojiLibraryView: View {
    @StateObject var emojiCatalogue = EmojiCatalogue()
    @StateObject var emojiReactionModel: EmojiReactionModel
    @StateObject var reactionViewModel: ReactionViewModel
    @Binding var showEmojiLibrary: Bool
    @Binding var longPress: Int
    @Binding var chosenEmoji: Emoji
    @Binding var emojiSelected: Bool
    @Binding var blur: Int
    @Binding var disableScroll: Int
    let postUID: String
    @Binding var showPicker: Bool
    @State var searchText = String()
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding(20)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(searchResults) { result in
                        Button(action: {
                            showEmojiLibrary.toggle()
                            emojiReactionModel.uploadReaction(postUID: postUID, emoji: result)
                            longPress = 0
                            blur = 0
                            disableScroll = 1000
                            showPicker = false
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            reactionViewModel.addLocalReaction(reaction: Emoji(emoji: result.emoji, description: result.description))
                        }, label: {
                            Text(result.emoji)
                                .font(.system(size: 40))
                        })
                    }
                }
            }
            .frame(height: 50)
            ScrollView {
                ForEach(emojiCatalogue.library) { category in
                    VStack {
                        Text(category.name)
                            .foregroundColor(Color("Grey"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        LazyVGrid(columns: gridItemLayout) {
                            ForEach(category.emojis) { emoji in
                                Button(action: {
                                    showEmojiLibrary.toggle()
                                    emojiReactionModel.uploadReaction(postUID: postUID, emoji: emoji)
                                    longPress = 0
                                    blur = 0
                                    disableScroll = 1000
                                    showPicker = false
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                    impactHeavy.impactOccurred()
                                    reactionViewModel.addLocalReaction(reaction: Emoji(emoji: emoji.emoji, description: emoji.description))
                                }, label: {
                                    Text(emoji.emoji)
                                        .font(.system(size: 30))
                                })
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
        .background(.white)
    }
    private var searchResults: [Emoji] {
        var results = emojiCatalogue.emojis
        if searchText.isEmpty {
            return results
        }
        return results.filter {
            $0.description.lowercased().contains(searchText.lowercased()) || $0.emoji.contains(searchText)
        }
    }
}
