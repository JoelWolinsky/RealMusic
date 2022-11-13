
import FirebaseFirestore

class UserViewModel: ObservableObject {
    
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

        do {
            try db.collection("Users").document(uid).setData(from: user)
            UserDefaults.standard.setValue(username, forKey: "Username")
            print("user added")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    
  
    

}

