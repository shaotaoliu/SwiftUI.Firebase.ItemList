import SwiftUI
import FirebaseFirestore

struct ItemDetailView: View {
    @EnvironmentObject var vm: ItemViewModel
    @State private var editMode = false
    @State private var editingItem = Item()
    @State var item: Item
    
    var body: some View {
        if editMode {
            EditItemView(item: $editingItem)
                .navigationTitle("Edit Item")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: CancelButton, trailing: SaveButton)
        }
        else {
            ViewItemView(item: item)
                .navigationTitle("Item Detail")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: EditButton)
        }
    }
    
    var SaveButton: some View {
        Button("Save") {
            vm.update(item: editingItem)
            item = editingItem
            editMode = false
        }
    }
    
    var CancelButton: some View {
        Button("Cancel") {
            editMode = false
        }
    }
    
    var EditButton: some View {
        Button("Edit") {
            editingItem = item
            editMode = true
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Item())
            .environmentObject(ItemViewModel())
    }
}
