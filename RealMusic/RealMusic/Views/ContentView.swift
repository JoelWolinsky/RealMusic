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
    @State private var showWebView = false
    @State private var showHome = false
    
    @ObservedObject var SpotifyAPI2 = SpotifyAPI()

   // @State var showLoading: Bool = true
    var body: some View {
        // Sign in the user and authorize them before taking them to the main feed
        VStack {
            if viewModel.signedIn {
                   // .environment(viewModel: viewModel)
                
                HomeView()
                    .sheet(isPresented: $showWebView) {
                        WebView()
                    }
  
            } else {
                SignInView()
            }
            
        }.onAppear( perform: {
            viewModel.signedIn = viewModel.isSignedIn
            //viewModel.signedIn = false
            // check if token still valid here, make nil if so
            
            SpotifyAPI.shared.checkTokenExpiry { (result) in
                switch result {
                    case true:
                    print("token valid ")
                    //createPostModel.createPost(post: data[0])
                        
                    case false:
                    print("token expired")
                    showWebView = true
                    }
                }
            //UserDefaults.standard.setValue(nil, forKey: "Authorization")
            
            
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
