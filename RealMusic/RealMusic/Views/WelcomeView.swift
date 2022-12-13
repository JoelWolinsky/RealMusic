//
//  WelcomeView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 12/12/2022.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    
    @StateObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack{
           
            Text("Welcome to RealMusic")
                .font(.system(size: 30))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 5)

            Text("RealMusic is an app for you to share all your favourite music with your friends.")
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)

            Text("How to use:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            Text("1. Each day choose one song that you you have loved listening to and post it via either the 'Currently listening to' box or by searching for it")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

            Text("2. Scroll through your feed to see all the other songs posted by people that day and long press on a post to react to it or add it to your library")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

            Text("3. Add friends via their username and load your analytics to see how your music tastes match with them")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

            Text("Tip: You can only post one song per day and the post will dissapear after midnight so choose wisely!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)

            Text("If the app breaks try restarting it. And also, feel free to lmk if you think its crap")
                .frame(maxWidth: .infinity, alignment: .leading)

            
            Button {
                viewModel.welcomeMessage.toggle()
                
            } label: {
                Text("Continue")
                    .fontWeight(.medium)
            }
            .padding(20)
        }
        .padding(15)
        .padding(.bottom, 150)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .background(.black)
    }
        
//    struct WelcomeView_Previews: PreviewProvider {
//        static var previews: some View {
//            WelcomeView()
//            
//        }
//    }
        
}