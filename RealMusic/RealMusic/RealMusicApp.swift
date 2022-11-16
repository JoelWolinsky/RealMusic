//
//  RealMusicApp.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import WebKit

@main
struct RealMusicApp: App {
    // register app delegate for Firebase setup
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    

    var body: some Scene {
        WindowGroup {
            let viewModel = SignInViewModel()
            //let webview = WebView()
            //viewModel.getAccessTokenFromView()
            ContentView()
                .environmentObject(viewModel)
                
        }
        
    }
}
