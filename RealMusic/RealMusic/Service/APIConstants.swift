//
//  APIConstants.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 30/10/2022.
//

import Foundation

enum APIConstants {
    static let apiHost = "api.spotify.com"
    static let authHost = "accounts.spotify.com"
    static let cliendId = "b653039d43e64c13a313b7419148684a"
    static let clientSecret = "9b9dc6e081794f1d80c51ac11b958f0f"
    static let redirectUri = "https://www.google.co.uk/?client=safari"
    static let responseType = "token"
    static let scopes = "user-read-private"
    
    static var authParams = [
        "response_type": responseType,
        "client_id": cliendId,
        "redirect_uri": redirectUri,
        "scope": scopes
    ]

}
