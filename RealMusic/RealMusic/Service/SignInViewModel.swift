//
//  SignInViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 02/11/2022.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var welcomeMessage = false
    @ObservedObject var userViewModel = UserViewModel()

    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            // Fetch the users user name from db
            self.userViewModel.fetchUser(withId: self.auth.currentUser?.uid ?? "") { user in
                UserDefaults.standard.setValue(user.username, forKey: "username")
            }
            let token = Messaging.messaging().fcmToken
            let db = Firestore.firestore()
            do {
                try db.collection("DeviceTokens").document(self.auth.currentUser?.uid ?? "xxxx").setData(from: token)
                print("Device Token added")
            } catch {
                print("Error writing city to Firestore: \(error)")
            }

            UserDefaults.standard.setValue(self.auth.currentUser!.uid, forKey: "uid")
            self.signedIn = true
            self.welcomeMessage = true
            completion(true)
        }
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                return
            }
            var uid = self.auth.currentUser?.uid
            UserDefaults.standard.setValue(uid ?? "", forKey: "uid")
        }
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("could not sign out of firebase")
        }

        signedIn = false
    }
}
