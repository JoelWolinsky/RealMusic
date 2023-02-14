//
//  SignInViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 02/11/2022.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseMessaging
import FirebaseFirestore

class SignInViewModel: ObservableObject {
    let auth = Auth.auth()

    @Published var signedIn = false
    @Published var welcomeMessage = false

    
    @ObservedObject var userViewModel = UserViewModel()


    var isSignedIn: Bool {
        print("CURRENT USER \(auth.currentUser?.uid)")
        return auth.currentUser != nil
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print("wrong password")
                completion(false)
                return
            }
            
            
            // Fetch the users user name from db
            self.userViewModel.fetchUser(withId: self.auth.currentUser?.uid ?? "" ) { user in
                print(user.username)
                UserDefaults.standard.setValue(user.username, forKey: "username")
                
            }
            let token = Messaging.messaging().fcmToken
            
           
            let db = Firestore.firestore()
            //let post = Post(title: "Test Send Post", uid: "test uid")

            do {
                try db.collection("DeviceTokens").document(self.auth.currentUser?.uid ?? "xxxx").setData(from: token)
                print("Device Token added")
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            

            UserDefaults.standard.setValue(self.auth.currentUser!.uid, forKey: "uid")
            self.signedIn = true
            self.welcomeMessage = true
            completion(true)
        }
    }

    func signUp(email: String, password: String) {
        print("Signing up")
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print("returning")
                return
            }
            var uid = self.auth.currentUser?.uid
            self.welcomeMessage = true
            UserDefaults.standard.setValue(uid ?? "", forKey: "uid")
            print("uid \(uid)")


            

        }
    }
    
    

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("could not sign out of firebase")
        }
        

        self.signedIn = false
    }
}

