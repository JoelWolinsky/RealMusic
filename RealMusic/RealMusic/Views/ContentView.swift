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
                        //UserDefaults.standard.setValue(nil, forKey: "Authorization")
                        showWebView.showView = true
                    })
                // ADD once signed it and redirected to google to close sheet
            }
            
        }.onAppear( perform: {
            
            viewModel.signedIn = viewModel.isSignedIn
            //viewModel.signedIn = false
            //test = "hello world"
            // check if token still valid here, make nil if so
            //UserDefaults.standard.setValue("hello world", forKey: "Authorization")

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
//            spotifyAPI.search(input: "") { (result) in
//                switch result {
//                    case .success(let data) :
//                    print("success 123\(data)")
//                    print("SEARCH success")
//                    //showWebView.showView = false
//                    case .failure(let error) :
//                    print("SEARCH fail")
//                    //showWebView.showView = true
//                    }
//                }
            
            
//            if let token = UserDefaults.standard.value(forKey: "Authorization") {
//                showWebView = false
//            }
            //UserDefaults.standard.setValue(nil, forKey: "Authorization")
            }
        )

    }
        
}

//struct SignInView: View {
//
//    @State var email = ""
//    @State var password = ""
//
//    @EnvironmentObject var viewModel: SignInViewModel
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Sign In")
//
//                TextField("Email address", text: $email)
//                SecureField("Email address", text: $password)
//
//                Button(action: {
//                    viewModel.signIn(email: email, password: password)
//                }, label: {
//                    Text("Sign in")
//                })
//
//
//                NavigationLink (destination: SignUpView()) {
//                    Text("Create Account")
//                }
//            }
//
//        }
//
//
//
//    }
//}
//
//struct SignUpView: View {
//
//    @State var email = ""
//    @State var password = ""
//
//    @EnvironmentObject var viewModel: SignInViewModel
//
//    var body: some View {
//        VStack {
//            Text("Sign Up")
//
//            TextField("Email address", text: $email)
//            SecureField("Email address", text: $password)
//
//            Button(action: {
//                viewModel.signUp(email: email, password: password)
//            }, label: {
//                Text("Sign Up")
//            })
//        }
//
//
//
//    }
//}
