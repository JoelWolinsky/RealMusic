//
//  SignInView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 27/10/2022.
//

import Foundation
import SwiftUI

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

// This is the view handler
struct ContentView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    //@State private var showWebView = false
    @State private var showHome = false
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    @ObservedObject var feedViewModel = FeedViewModel()
    
    @ObservedObject var showWebView = showView(showView: false)
    
    //@Binding var test: String

   // @State var showLoading: Bool = true
    var body: some View {
        // Sign in the user and authorize them before taking them to the main feed
        VStack {
//            Text(test)
//                .foregroundColor(.orange)
            if viewModel.signedIn {
                   // .environment(viewModel: viewModel)
                
                HomeView(feedViewModel: feedViewModel)
                    .sheet(isPresented: $showWebView.showView) {
                        WebView(showWebView: showWebView)
//                            .onDisappear(perform: {
//                                print("disapear")
//                                feedViewModel.fetchPosts()
//                            })
//
                        
                    }
  
            } else {
                SignInView(viewModel: viewModel)
                    .onAppear(perform: {
                        showWebView.showView = true
                    })
                // ADD once signed it and redirected to google to close sheet
            }
            
        }.onAppear( perform: {
            
            viewModel.signedIn = viewModel.isSignedIn
            //viewModel.signedIn = false
            //test = "hello world"
            // check if token still valid here, make nil if so
            if UserDefaults.standard.value(forKey: "username") == nil {
                UserDefaults.standard.setValue("no username found",forKey: "username")
            }

            SpotifyAPI.shared.checkTokenExpiry { (result) in
                switch result {
                    case true:
                    print("aaaa token valid ")
                
                    showWebView.showView = false
                    //createPostModel.createPost(post: data[0])

                    case false:
                    print("aaaa token expired")
                    showWebView.showView = true
                    }
                }

            }
        )

    }
        
}

