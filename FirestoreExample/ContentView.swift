import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var vm: ItemViewModel
    @State private var deleteSet: IndexSet? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.filteredItems, id: \.id) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        Text(item.name)
                    }
                }
                .onDelete { indexSet in
                    self.deleteSet = indexSet
                    vm.showDeleteConfirmation = true
                }
            }
            .searchable(text: $vm.searchText)
            .listStyle(.plain)
            .navigationTitle("Items")
            .navigationBarItems(trailing: AddButton)
            .confirmationDialog("Confirm", isPresented: $vm.showDeleteConfirmation, actions: {
                Button("Delete") {
                    if let deleteSet = deleteSet {
                        for index in deleteSet {
                            vm.delete(item: vm.items.first { $0.id == vm.filteredItems[index].id }!)
                        }
                    }
                }
            }, message: {
                Text("Are you sure to delete it?")
            })
        }
    }
    
    var AddButton: some View {
        Button("Add") {
            vm.showAddView = true
        }
        .sheet(isPresented: $vm.showAddView) {
            AddItemView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ItemViewModel())
    }
}
