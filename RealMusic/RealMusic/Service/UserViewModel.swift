
import FirebaseFirestore

class UserViewModel: ObservableObject {
    
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
    
    
  
    

}

