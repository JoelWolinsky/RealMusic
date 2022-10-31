//
//  WebView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 31/10/2022.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    //let var showLoading: Bool
    
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
//        guard let urlRequest = SpotifyAPI.shared.getAccessTokenURL() else { return }
//        let webview = WKWebView()
//
//        print("loading webview")
//        print(urlRequest)
//        webview.load(urlRequest)
//        //return webview
        }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(didStart: {
            //showLoading = true
        }, didFinish: {
            //showLoading = false
        })
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    
    var didStart: () -> Void
    var didFinish: () -> Void
    
    init(didStart: @escaping () -> Void = {}, didFinish: @escaping () -> Void = {}) {
        self.didStart = didStart
        self.didFinish = didFinish
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigaition: WKNavigation!) {
        print("did start")
        didStart()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish")
        let urlString = webView.url?.absoluteString //else { return }
        //print(urlString)
        print("error")
        
//        if urlString.contains("#access_token=") {
//            print("contains token")
//            let range = urlString.range(of: "#access_token=")
//            guard let index = range?.upperBound else { return }
//            print(urlString[index...])
//
//        } else {
//            print("Doesn't contain token")
//        }

        //didFinish()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         print(error)
    }
}
