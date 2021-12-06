import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LearnViewModel {
    private let db = Firestore.firestore()
    
    func setDataWithAnId() {
        db.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ])
        
        db.collection("cities").document("LA").getDocument { document, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            if let doc = document, doc.exists {
                print(doc.data()!["name"] as! String)
                print(doc.data()!["state"] as! String)
                print(doc.data()!["country"] as! String)
            }
            else {
                print("Not found")
            }
        }
    }
    
    func saveDifferentDataTypes() {
        let data: [String: Any] = [
            "stringExample": "Hello",
            "booleanExample": true,
            "numberExample": 3.1415926,
            "dateExample": Timestamp(date: Date()),
            "arrayExample": [5, true, "Hello"],
            "objectExample": [
                "a": 5,
                "b": false,
                "c": "World",
                "d": [
                    "nested": "Done"
                ]
            ]
        ]
        
        db.collection("test").document("one").setData(data)
        
        db.collection("test").document("one").getDocument { document, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            if let doc = document, doc.exists {
                print(doc.data()!["stringExample"] as! String)
                print(doc.data()!["booleanExample"] as! Bool)
                print(doc.data()!["numberExample"] as! Double)
                print((doc.data()!["dateExample"] as! Timestamp).dateValue())
                print(doc.data()!["arrayExample"] as! [Any])
                print(doc.data()!["objectExample"]!)
            }
            else {
                print("Not found")
            }
        }
    }
    
    struct City: Codable {
        let name: String
        let state: String?
        let country: String?
        let isCapital: Bool?
        let population: Int64?
        
        enum CodingKeys: String, CodingKey {
            case name
            case state
            case country
            case isCapital = "capital"
            case population
        }
    }
    
    func saveCustomObject() {
        let city = City(name: "Las Vegas",
                        state: "UT",
                        country: "USA",
                        isCapital: true,
                        population: 2000000)
        
        do {
            try db.collection("cities").document("LV").setData(from: city)
        }
        catch {
            print("\(error)")
        }
        
        db.collection("cities").document("LV").getDocument { document, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            if let doc = document, doc.exists {
                do {
                    if let city = try doc.data(as: City.self) {
                        print(city)
                    }
                }
                catch {
                    // decoding error
                    print("\(error)")
                }
            }
            else {
                print("Not found")
            }
        }
    }
    
    func updateNestedField() {
        db.collection("users").document("frank").setData([
            "favorites": [
                "food": "Pizza",
                "color": "Blue"
            ]
        ])

        db.collection("users").document("frank").updateData([
            "favorites.color": "Red"
        ])
        
//        db.collection("users").document("frank").updateData([
//            "favorites.size": "Large"
//        ])
        
//        db.collection("users").document("frank").updateData([
//            "favorites": [
//                "color": "Red"
//            ]
//        ])
    }
    
    func updateArray() {
        db.collection("users").document("frank").setData([
            "colors": ["Red", "Green", "Blue"]
        ])

        db.collection("users").document("frank").updateData([
            "colors": FieldValue.arrayUnion(["Yellow", "Gray"])
        ])
        
        db.collection("users").document("frank").updateData([
            "colors": FieldValue.arrayRemove(["Green", "Blue"])
        ])
    }
    
    func updateNumber() {
        db.collection("users").document("frank").setData([
            "age": 20
        ])
        
        db.collection("users").document("frank").updateData([
            "age": FieldValue.increment(Int64(5))
        ])
    }
    
    func delete() {
        db.collection("users").document("frank").setData([
            "favorites": [
                "food": "Pizza",
                "color": "Blue"
            ]
        ])

        db.collection("users").document("kevin").setData([
            "gender": "Male",
            "race": "Asian"
        ])
        
//        db.collection("users").document("frank").updateData([
//            "favorites.color": FieldValue.delete()
//        ])
//
//        db.collection("users").document("kevin").updateData([
//            "race": FieldValue.delete()
//        ])
//
//        db.collection("users").document("kevin").delete()
    }
    
    func transaction() {
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let reference = self.db.collection("cities").document("LV")
            let document: DocumentSnapshot
            
            do {
                document = try transaction.getDocument(reference)
            }
            catch {
                errorPointer?.pointee = error as NSError
                return nil
            }

            guard let population = document.data()?["population"] as? Int else {
                errorPointer?.pointee = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve population"])
                
                return nil
            }

            transaction.updateData(["population": population + 1], forDocument: reference)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
    func batch() {
        let batch = db.batch()
        
        batch.setData(["name": "New York"], forDocument: db.collection("cities").document("NY"))
        batch.updateData(["population": 2500000], forDocument: db.collection("cities").document("LV"))
        batch.deleteDocument(db.collection("cities").document("LA"))

        batch.commit() { error in
            if let error = error {
                print("Error writing batch \(error)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func addListenerToNY() {
        db.collection("cities").document("NY").addSnapshotListener { snapshot, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            print("Current data: \(snapshot!.data()!)")
        }
    }
    
    func changeNY() {
        db.collection("cities").document("NY").updateData([
            "state": "NY",
            "country": "USA"
        ])
        
        db.collection("cities").document("SD").setData([
            "name": "SanDiego",
            "state": "CA",
            "country": "USA"
        ])
        
        db.collection("cities").document("LA").setData([
            "name": "Los Angel",
            "state": "CA",
            "country": "USA"
        ])
    }
    
    func addListenerToCA() {
        db.collection("cities").whereField("state", isEqualTo: "CA").addSnapshotListener { snapshot, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            snapshot!.documentChanges.forEach { change in
                switch change.type {
                case .added:
                    print("Added: \(change.document.data())")
                    
                case .modified:
                    print("Modified: \(change.document.data())")
                    
                case .removed:
                    print("Deleted: \(change.document.data())")
                }
            }
        }
    }
    
    func addCitiesInCA() {
        db.collection("cities").document("SF").setData([
            "name": "San Francisco",
            "state": "CA",
            "country": "USA"
        ])
        
        db.collection("cities").document("LA").updateData([
            "name": "Los Angeles"
        ])
        
        db.collection("cities").document("SD").delete()
    }
    
    func subcollection() {
        db.collection("cities").document("LA").collection("landmarks").addDocument(data: [
            "name": "Griffith Park",
            "type": "Park"
        ])
        
        db.collection("cities").document("LA").collection("landmarks").addDocument(data: [
            "name": "The Getty",
            "type": "Museum"
        ])
        
        db.collection("cities").document("SF").collection("landmarks").addDocument(data: [
            "name": "Legion of Honor",
            "type": "Museum"
        ])

        db.collection("cities").document("DC").collection("landmarks").addDocument(data: [
            "name": "National Air and Space Museum",
            "type": "Museum"
        ])
        
        db.collectionGroup("landmarks").whereField("type", isEqualTo: "museum").getDocuments { (snapshot, error) in
            if let error = error {
                print("\(error)")
                return
            }
            
            if let snap = snapshot {
                for doc in snap.documents {
                    print("\(doc.data())")
                }
            }
        }
    }
    
    func orderAndLimit() {
        db.collection("cities")
            .order(by: "state")
            .order(by: "name", descending: true)
            .limit(to: 5)
    }
}
