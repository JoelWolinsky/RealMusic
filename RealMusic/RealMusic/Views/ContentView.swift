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
    @EnvironmentObject var signInViewModel: SignInViewModel
    //@State private var showWebView = false
    @State private var showHome = false
    
    @ObservedObject var spotifyAPI = SpotifyAPI()
    
    @State var showWebView = false
    
    //@Binding var test: String

   // @State var showLoading: Bool = true
    var body: some View {
        // Sign in the user and authorize them before taking them to the main feed
        VStack {
//            Text(test)
//                .foregroundColor(.orange)
            if signInViewModel.signedIn && UserDefaults.standard.value(forKey: "uid") != nil {
                   // .environment(viewModel: viewModel)
                
                HomeView(welcomeMessage: signInViewModel.welcomeMessage, showWebView: $showWebView)
                    .sheet(isPresented: $signInViewModel.welcomeMessage) {
                        WelcomeView(signInViewModel: signInViewModel)
                            .interactiveDismissDisabled()
                            .onDisappear(perform: {
                                print("welcome view has dissapread")
                                if UserDefaults.standard.value(forKey: "auth") == nil {
                                    UserDefaults.standard.set("no key yet", forKey: "auth")
                                }
                                SpotifyAPI.shared.checkTokenExpiry { (result) in
                                    switch result {
                                        case true:
//                                        print("aaaa token valid ")
                                        showWebView = false
                                        //feedViewModel.fetchPosts()
                                        //createPostModel.createPost(post: data[0])

                                        case false:
//                                        print("aaaa token expired")
                                        showWebView = true
                                        }
                                    }
                            })
                    }
                    .sheet(isPresented: $showWebView) {
                        WebView(showWebView: $showWebView)
                            .onDisappear(perform: {
                                print("disapear")
                                //feedViewModel.fetchPosts()
                                SpotifyAPI.shared.checkTokenExpiry { (result) in
                                    switch result {
                                        case true:
//                                        print("aaaa token valid ")
                                        showWebView = false
                                        //feedViewModel.fetchPosts()
                                        //createPostModel.createPost(post: data[0])

                                        case false:
//                                        print("aaaa token expired")
                                        showWebView = true
                                        }
                                    }
                            })
                            .interactiveDismissDisabled()



                    }
                    .interactiveDismissDisabled()
              
    

  
            } else {
                SignInView(signInViewModel: signInViewModel)
                    .onAppear(perform: {
                        if signInViewModel.isSignedIn == false {
                            print("set token to nil")
                            UserDefaults.standard.set(nil, forKey: "auth")

                        }
                    })
                    .onDisappear(perform: {
                        if UserDefaults.standard.value(forKey: "auth") == nil {
                            UserDefaults.standard.set("no key yet", forKey: "auth")
                        }
                        SpotifyAPI.shared.checkTokenExpiry { (result) in
                            switch result {
                                case true:
//                                print("aaaa token valid ")
                                showWebView = false
                                //feedViewModel.fetchPosts()
                                //createPostModel.createPost(post: data[0])

                                case false:
//                                print("aaaa token expired")
                                showWebView = true
                                }
                            }
                    })
//                    .onAppear(perform: {
//                        showWebView = true
//                    })
                // ADD once signed it and redirected to google to close sheet
            }
            
        }
        .accentColor(.black)
        .onAppear( perform: {
            
            signInViewModel.signedIn = signInViewModel.isSignedIn
            
            //viewModel.signedIn = false
            //test = "hello world"
            // check if token still valid here, make nil if so
            if UserDefaults.standard.value(forKey: "username") == nil {
                UserDefaults.standard.setValue("no username found",forKey: "username")
            }


            }
        )
        .accentColor(.white)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            print("App is active")
            
            SpotifyAPI.shared.checkTokenExpiry { (result) in
                switch result {
                    case true:
//                    print("aaaa token valid ")
                    showWebView = false
                    //feedViewModel.fetchPosts()
                    //createPostModel.createPost(post: data[0])

                    case false:
//                    print("aaaa token expired")
                    showWebView = true
                    }
                }

        }

        

    }
        
}


