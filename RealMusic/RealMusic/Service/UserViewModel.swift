
import FirebaseFirestore
import SwiftUI
import FirebaseStorage

class UserViewModel: ObservableObject {
    
//    @State var nameTaken = false
    
    // Fetch data for a user given their id
    func fetchUser(withId id: String, completion: @escaping(User) -> Void ) {
        let db = Firestore.firestore()
        db.collection("Users")
            .document(id)
            .getDocument() { snapshot, _ in
                guard let snapshot = snapshot else { print("no user"); return }
                guard let user = try? snapshot.data(as: User.self) else { print("fail user"); return }
                completion(user)
            }
    }
    
    
    
    // Fetch all the users
    func fetchUsers(completion: @escaping([User]) -> Void ) {
        var users = [User]()
        let db = Firestore.firestore()
        db.collection("Users")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else { return }
                documents.forEach{ user in
                    guard let user = try? user.data(as: User.self) else { return }
                    users.append(user)
                }
                completion(users)
            }
    }
    
    
    
    func createUser(uid: String, username: String, profilePic: String) {
        let db = Firestore.firestore()
        
        let user = User(id: uid, username: username, profilePic: profilePic)
        print("user id \(uid)")
        do {
            try db.collection("Users").document(uid).setData(from: user)
            UserDefaults.standard.setValue(username, forKey: "username")
            print("user added")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    // Fetch friends of a user
    func fetchFriends(withId id: String, completion: @escaping([User]) -> Void ) {
        var friends = [User]()
        let db = Firestore.firestore()
        db.collection("Users")
            .document(id)
            .collection("Friends")
            .getDocuments() { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else { return }
                documents.forEach{ user in
                    guard let user = try? user.data(as: User.self) else { return }
                    friends.append(user)
                    print("fetched friend \(user.id)")
                }
                completion(friends)
            }
    }
    
    func addFriend(friend: User) {
        let db = Firestore.firestore()
        
        let userUid = UserDefaults.standard.value(forKey: "uid")
        
        // add them to your friends
        do {
            try db.collection("Users").document(userUid as! String).collection("Friends").document(friend.id as! String).setData(from: friend)
            print("friend added")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
//        // add you to their friends
//        do {
//            try db.collection("Users").document(friend.id ?? "").collection("Friends").document(userUid as! String)
//                .setData(from: User(id: userUid as? String,
//                                    username: UserDefaults.standard.value(forKey: "username") as? String ?? "" ))
//            print("friend added")
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//        }
    }
    
    func removeFriend(friend: User) {
        let db = Firestore.firestore()
        
        let userUid = UserDefaults.standard.value(forKey: "uid")
        
        // add them to your friends
        do {
            try db.collection("Users").document(userUid as! String).collection("Friends").document(friend.id as! String).delete()
            print("friend added")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
        
    }
    
    func fetchProfilePic (uid: String, completion: @escaping(String) -> Void) {
                
        print("Fetching profile pic for \(uid)")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to download
        let riversRef = storageRef.child("images/\(uid).heic")
        //let riversRef = storageRef.child("images/rivers.heic")

        // Fetch the download URL
        riversRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
              print("profile pic \(url)")
              completion(url?.absoluteString ?? "no profile")
            // Get the download URL for 'images/stars.jpg'
          }
        }
    }
    
    
    
    
  
    

}

