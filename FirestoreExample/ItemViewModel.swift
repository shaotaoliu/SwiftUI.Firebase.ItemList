import Foundation

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var searchText = ""
    @Published var showAddView = false
    @Published var showDeleteConfirmation = false
    @Published var hasError = false
    @Published var errorMessage: String? = nil {
        didSet {
            hasError = errorMessage != nil
        }
    }
    
    var filteredItems: [Item] {
        (searchText.isEmpty ? items : items.filter { $0.name.localizedCaseInsensitiveContains(searchText) })
            .sorted { $0.name < $1.name }
    }
    
    init() {
        getAll()
    }
    
    private let repository = ItemRepository()
    
    func add(item: Item, completion: ((Bool?) -> Void)? = nil) {
        if item.name.isEmpty {
            errorMessage = "Name cannot be empty"
            completion?(false)
            return
        }
        
        if item.description.isEmpty {
            errorMessage = "Description cannot be empty"
            completion?(false)
            return
        }
        
        repository.add(item: item) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion?(false)
                return
            }
            
            self.getAll()
            completion?(true)
        }
    }
    
    func getAll() {
        repository.getAll { (items, error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.items = items ?? []
        }
    }
    
    func delete(item: Item) {
        repository.delete(item: item) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.getAll()
        }
    }
    
    func update(item: Item) {
        repository.update(item: item) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.getAll()
        }
    }
}
