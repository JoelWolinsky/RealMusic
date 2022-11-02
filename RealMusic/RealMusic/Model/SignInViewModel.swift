//
//  SignInViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 02/11/2022.
//

import Foundation
import SwiftUI
import FirebaseAuth

class SignInViewModel: ObservableObject {
    let auth = Auth.auth()

    @Published var signedIn = false

    var isSignedIn: Bool {
        print("CURRENT USER \(auth.currentUser)")
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
}

