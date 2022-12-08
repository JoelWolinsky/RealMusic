//
//  PostReactionsListItemView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 08/12/2022.
//

import Foundation
import SwiftUI

struct PostReactionsListItemView: View {
    
    @StateObject var userViewModel: UserViewModel
    
    @State var reaction: Emoji
    
    @State var user = User(username: "")

    
    var body: some View {
        
        HStack {
            AsyncImage(url: URL(string: user.profilePic ?? "no profile pic")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                Color.black
            }
            .frame(width: 50, height: 50)
            .cornerRadius(30)
            
            Text(user.username)
                .foregroundColor(.white)
                .padding(.leading, 5)
            Spacer()
            Text(reaction.emoji)
                .font(.system(size: 30))

        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .onAppear(perform: {
            userViewModel.fetchUser(withId: reaction.docID ?? "") { userFound in
                user = userFound
            }
            
//            userViewModel.fetchProfilePic(uid: friend.id!) { profile in
//                print(profile)
//            }
        })
        

    }
        
}
