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
    @State var profilePic = String()

    var body: some View {
        HStack {
            if let url = URL(string: profilePic) {
                CacheAsyncImage(url: url) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                    case let .failure(error):
                        Rectangle()
                            .background(.black)
                            .foregroundColor(.black)
                            .frame(width: 100, height: 110)
                    case .empty:
                        Rectangle()
                            .background(.black)
                            .foregroundColor(.black)
                            .frame(width: 100, height: 110)
                    }
                }
                .frame(width: 50, height: 50)
                .cornerRadius(30)
            }
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
            userViewModel.fetchProfilePic(uid: reaction.docID ?? "") { profile in
                profilePic = profile
            }
        })
    }
}
