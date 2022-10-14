//
//  ContentView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct ContentView: View {
    
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        
        //var posts = [Post(title: "This is a test", userID: "This userID test", username: "Woli")]
        ZStack {
            ScrollView {
                VStack{
                    ForEach(viewModel.posts) { post in
                        PostView(post: post)
                    }
                }
                .padding()
            }
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.white)
                    .font(.system(size:20))
                Spacer()
                Text("Real Music")
                    .foregroundColor(.white)
                    .font(.system(size:25))
                    .fontWeight(.bold)
                Spacer()
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
                
        }
    .background(.black)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
    
    
}


