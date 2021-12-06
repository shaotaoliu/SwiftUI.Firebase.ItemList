import SwiftUI

struct ViewItemView: View {
    var item: Item
    
    var body: some View {
        VStack {
            Form {
                Text(item.name)
                Text(item.description)
            }
        }
    }
}

struct ViewItemView_Previews: PreviewProvider {
    static var previews: some View {
        ViewItemView(item: Item(name: "Example", description: "This is an example"))
    }
}
