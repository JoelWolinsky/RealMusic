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
    
    //@ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    @State var emojiSize = 20.0
    
    var body: some View {
        HStack {
            ForEach(reactionViewModel.distinctReactions) { emoji in
                if emoji.docID == UserDefaults.standard.value(forKey: "uid") as! String {
                    Text(emoji.emoji)
                        .font(.system(size: emojiSize))
                } else {
                    Text(emoji.emoji)
                        .font(.system(size: 20))
                        .onAppear(perform:{
                            print("user uid \(emoji.docID)")
                            print("user uid saved \(UserDefaults.standard.value(forKey: "uid") as! String)")

                        })
                }
//                    .onAppear {
////                        cancellable = reactionViewModel.objectWillChange.sink{ _ in
////                            print("object changed")
////                        }
//                        let baseAnimation = Animation.easeInOut(duration: 0.4)
//                        let repeated = baseAnimation.repeatCount(3, autoreverses: true)
//
//                        withAnimation(repeated) {
//                            emojiSize = 20.0
//                        }
//                    }//
                
            }
            //.padding(10)

            if reactionViewModel.distinctReactions.count != reactionViewModel.reactions.count {
                    Text(String(reactionViewModel.reactions.count))
                        .foregroundColor(.white)
                
            }

        }
        //.frame(maxWidth: CGFloat(reactionViewModel.reactions.count * 25) + 50, maxHeight: 40)
        .frame(minWidth: reactionViewModel.distinctReactions.isEmpty ? 0 : 20)
        .padding(reactionViewModel.distinctReactions.isEmpty ? 0 : 10)
        .background(Color("Grey 3"))
        //.cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black, lineWidth: 5)
                )
        .cornerRadius(40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onReceive(reactionViewModel.objectWillChange, perform: {
            if !reactionViewModel.reactions.isEmpty {
                print("seen object change \(reactionViewModel.reactions)")
                emojiSize = 2.0
                
                //            let baseAnimation = Animation.easeInOut(duration: 0.6)
                //            let repeated = baseAnimation.repeatCount(2, autoreverses: true)
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                    emojiSize = 20.0
                }
            }
        })
        


        
    }
        
    
//    struct EmojiView_Previews: PreviewProvider {
//        static var previews: some View {
//            //ReactionsView(reactionViewModel: ReactionViewModel(id: ""), post: "")
//            
//        }
//    }
}

