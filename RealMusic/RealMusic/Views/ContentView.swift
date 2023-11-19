//
//  ContentView.swift
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
    @State private var showHome = false
    @ObservedObject var spotifyAPI = SpotifyAPI()
    @State var showWebView = false

    var body: some View {
        // Sign in the user and authorize them before taking them to the main feed
        VStack {
            if signInViewModel.signedIn && UserDefaults.standard.value(forKey: "uid") != nil {
                HomeView(welcomeMessage: signInViewModel.welcomeMessage, showWebView: $showWebView)
                    .sheet(isPresented: $signInViewModel.welcomeMessage) {
                        WelcomeView(signInViewModel: signInViewModel)
                            .interactiveDismissDisabled()
                            .onDisappear(perform: {
                                print("welcome view has dissapread")
                                if UserDefaults.standard.value(forKey: "auth") == nil {
                                    UserDefaults.standard.set("no key yet", forKey: "auth")
                                }
                                SpotifyAPI.shared.checkTokenExpiry { result in
                                    switch result {
                                    case true:
                                        showWebView = false
                                    case false:
                                        showWebView = true
                                    }
                                }
                            })
                    }
                    .sheet(isPresented: $showWebView) {
                        WebView(showWebView: $showWebView)
                            .onDisappear(perform: {
                                print("disapear")
                                SpotifyAPI.shared.checkTokenExpiry { result in
                                    switch result {
                                    case true:
                                        showWebView = false
                                    case false:
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
                            // Set every token to nil
                            UserDefaults.standard.set(nil, forKey: "auth")
                        }
                    })
                    .onDisappear(
                        perform: {
                            if UserDefaults.standard.value(forKey: "auth") == nil {
                                UserDefaults.standard.set("no key yet", forKey: "auth")
                            }
                            SpotifyAPI.shared.checkTokenExpiry { result in
                                switch result {
                                case true:
                                    showWebView = false
                                case false:
                                    showWebView = true
                                }
                            }
                        }
                    )
            }
        }
        .accentColor(.black)
        .onAppear(
            perform: {
                signInViewModel.signedIn = signInViewModel.isSignedIn
                // check if token still valid here, make nil if so
                if UserDefaults.standard.value(forKey: "username") == nil {
                    UserDefaults.standard.setValue("no username found", forKey: "username")
                }
            }
        )
        .accentColor(.white)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
            SpotifyAPI.shared.checkTokenExpiry { result in
                switch result {
                case true:
                    showWebView = false
                case false:
                    showWebView = true
                }
            }
        }
    }
}
