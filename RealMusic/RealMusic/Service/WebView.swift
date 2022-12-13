//
//  WebView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 31/10/2022.
//

import Foundation
import SwiftUI
import WebKit


// WebView is used to authorize the users using their Spotify account
struct WebView: UIViewRepresentable {
    
    //let var showLoading: Bool
    
    @Binding var showWebView: Bool
    
    func makeUIView(context: Context) -> some UIView {
        let urlRequest = SpotifyAPI.shared.getAccessTokenURL() //else { return  }
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        print("loading webview")
        print(urlRequest)
        webview.load(urlRequest!)
            
        return webview
        }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("update ui")

        }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(didStart: {
            //showLoading = true
        }, didFinish: {
            print("error2")
            //showWebView = false
            //need to sort this out
            
            

            //showLoading = false
        }, receivedToken: {
            print("Received token")
            showWebView = false
        })
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    
    var didStart: () -> Void
    var didFinish: () -> Void
    var receivedToken: () -> Void
    
    init(didStart: @escaping () -> Void = {}, didFinish: @escaping () -> Void = {}, receivedToken: @escaping () -> Void = {}) {
        self.didStart = didStart
        self.didFinish = didFinish
        self.receivedToken = receivedToken
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigaition: WKNavigation!) {
        print("did start")
        didStart()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinish()
        print("did finish")
        guard let urlString = webView.url?.absoluteString else { return }
        print(urlString)
        print("error")
        
        var tokenString = ""
        
        if urlString.contains("#access_token=") {
            print("contains token")
            let range = urlString.range(of: "#access_token=")
            guard let index = range?.upperBound else { return }
            tokenString = String(urlString[index...])
            

        }
        
        if !tokenString.isEmpty {
            let range = tokenString.range(of: "&token_type=Bearer")
            guard let index = range?.lowerBound else { return }
            
            tokenString = String(tokenString[..<index])
            UserDefaults.standard.setValue(tokenString, forKey: "authorization")
            print("set token")
            //showWebView = false
            receivedToken()
            
        }
        
        print("token \(tokenString)")

       
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         print(error)
    }
}
