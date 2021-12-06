import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var vm: ItemViewModel
    @Binding var item: Item
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $item.name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Description", text: $item.description)
                    .textFieldStyle(.roundedBorder)
            }
            .alert("Error", isPresented: $vm.hasError, presenting: vm.errorMessage, actions: { errorMessage in
                
            }, message: { errorMessage in
                Text(errorMessage)
            })
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: .constant(Item(name: "Example", description: "This is an example")))
            .environmentObject(ItemViewModel())
    }
}
