# SwiftUI.Firebase.ItemList

![image](https://user-images.githubusercontent.com/15805568/144916424-adedf8a3-e17a-4545-823c-9d35d373e294.png)

```Swift
import Foundation
import Firebase

class ItemRepository {
    private let collection = Firestore.firestore().collection("items")
    
    func add(item: Item, completion: @escaping (Error?) -> Void) {
        collection.addDocument(data: [
            "name": item.name,
            "description": item.description
        ]) { error in
            completion(error)
        }
    }
    
    func getAll(completion: @escaping ([Item]?, Error?) -> Void) {
        collection.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var items = [Item]()
            
            if let snapshot = snapshot {
                items = snapshot.documents.map { doc in
                    Item(id: doc.documentID,
                         name: doc.data()["name"] as! String,
                         description: doc.data()["description"] as! String)
                }
            }
            
            completion(items, nil)
        }
    }
    
    func delete(item: Item, completion: @escaping (Error?) -> Void) {
        collection.document(item.id).delete() { error in
            completion(error)
        }
    }
    
    func update(item: Item, completion: @escaping (Error?) -> Void) {
        collection.document(item.id).updateData([
            "name": item.name,
            "description": item.description
        ]) { error in
            completion(error)
        }
    }
}

```
