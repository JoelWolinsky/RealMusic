
import FirebaseFirestore
import SwiftUI

class UserViewModel: ObservableObject {
    
    @State var nameTaken = false
    
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
    
    
    
    func createUser(uid: String, username: String) {
        let db = Firestore.firestore()
        
        let user = User(id: uid, username: username)
        
//        self.fetchUsers() { users in
//            //print(user.username)
//            //UserDefaults.standard.setValue(user.username, forKey: "Username")
//            //var nameTaken = false
//            print("print usernames")
//            for user in users {
//                print(user.username)
//                if username == user.username {
//                    self.nameTaken = true
//
//                }
//            }
//        }
        
        //print("name taken \(nameTaken)")
        do {
            try db.collection("Users").document(uid).setData(from: user)
            UserDefaults.standard.setValue(username, forKey: "Username")
            print("user added")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    
  
    

}

