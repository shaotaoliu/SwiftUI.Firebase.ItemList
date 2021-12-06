import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ItemViewModel
    @State var newItem = Item()
    
    var body: some View {
        NavigationView {
            EditItemView(item: $newItem)
                .navigationTitle("New Item")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: CancelButton, trailing: SaveButton)
        }
    }
    
    var SaveButton: some View {
        Button("Save") {
            vm.add(item: newItem)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var CancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
            .environmentObject(ItemViewModel())
    }
}
