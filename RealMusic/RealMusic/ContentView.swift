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
        NavigationView {
            ScrollView {
                VStack{
                    ForEach(viewModel.posts) { post in
                        PostView(post: post)
                    }
                }.padding()
            }
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
        }
    }
    
    
}


