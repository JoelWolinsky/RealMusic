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


class SignInViewModel: ObservableObject {
    let auth = Auth.auth()

    @Published var signedIn = false

    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                return
            }
            
            self.signedIn = true
        }
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                return
            }
        }
    }

    func signOut() {
        try? auth.signOut()

        self.signedIn = false
    }
    
//    func getAccessTokenFromView() {
//        guard let urlRequest = SpotifyAPI.shared.getAccessTokenURL() else { return }
//        let webview = WKWebView()
//
//        webview.load(urlRequest)
//        webview.navigationDelegate = self
//        //view = webview
//
//
//
//    }
}


struct WebView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
    
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let urlRequest = SpotifyAPI.shared.getAccessTokenURL() else { return }
        let webview = WKWebView()
        print("loading webview")
        webview.load(urlRequest)
        }
    
    
//    func getAccessTokenFromView() {
//        guard let urlRequest = SpotifyAPI.shared.getAccessTokenURL() else { return }
//        let webview = WKWebView()
//
//        webview.load(urlRequest)
//        //webview.navigationDelegate = self
//        //view = webview
//
//
//    }
}


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
