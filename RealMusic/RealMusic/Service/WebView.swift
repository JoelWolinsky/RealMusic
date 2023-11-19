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
    @Binding var showWebView: Bool

    func makeUIView(context: Context) -> some UIView {
        var urlRequest = SpotifyAPI.shared.getAccessTokenURL() // else { return  }
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        webview.load(urlRequest!)
        return webview
    }

    func updateUIView(_: UIViewType, context _: Context) {
        print("update ui")
    }

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(didStart: {
        }, didFinish: {
            print("error2")
        }, receivedToken: {
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

    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        didStart()
    }

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        didFinish()
        guard let urlString = webView.url?.absoluteString else { return }
        var tokenString = ""
        if urlString.contains("#access_token=") {
            let range = urlString.range(of: "#access_token=")
            guard let index = range?.upperBound else { return }
            tokenString = String(urlString[index...])
        }

        if !tokenString.isEmpty {
            let range = tokenString.range(of: "&token_type=Bearer")
            guard let index = range?.lowerBound else { return }
            tokenString = String(tokenString[..<index])
            UserDefaults.standard.setValue(tokenString, forKey: "auth")
            UserDefaults.standard.synchronize()
            receivedToken()
        }
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        print(error)
    }
}
